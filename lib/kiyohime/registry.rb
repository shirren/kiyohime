require 'kiyohime/exceptions/subscriber_error'
require 'kiyohime/parsers/channel_parser'

module Kiyohime
  # A registry is a listing of services/functions which are accessible via a publish/subscribe paradigm. This
  # services/functions are accessible through the Publisher
  class Registry
    attr_reader :name, :channel_parser, :store, :hiredis

    # A registry should be provided with a name, and an underlying store. If the hiredis flag
    # is set to true we use the hiredis wrapper around redis instead
    def initialize(name, store, hiredis = true)
      @name = name
      @store = store
      @hiredis = hiredis
      @channel_parser = Kiyohime::Parsers::ChannelParser.new
    end

    # Non blocking registration of services. The run block creates an event loop, this allows
    # the process to continue and service publications via registered subscribers
    def register_async(*services)
      EM.run do
        # Here we create a pub/sub connection within a given EventMachine scope
        initialise_registry
        services.each { |service| register(service) }
      end
    end

    # Non blocking registration of services. The run block creates an event loop, this allows
    # the process to continue and service publications via registered subscribers
    def register_containers_async(*service_containers)
      EM.run do
        initialise_registry
        service_containers.each { |service_container| register_container(service_container) }
      end
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # particular channel, this means, the object must define a generic handler named handle. Multiple
    # services are registered in a single go using an evented publish subscribe approach
    def register(service)
      initialise_registry
      channel = channel_parser.parse_type_to_channel_name(service.class)
      if service.respond_to?(:handle)
        puts "Registering service: #{channel}"
        store.subscribe(channel) do |message|
          service.handle(message)
        end
      end
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # channel name derived using the service name and method name. This unlike the generic register
    # method which assumes the service implements a particular interface
    def register_container(service_container)
      initialise_registry
      service_container.methods.each do |method_name|
        channel = channel_parser.parse_type_and_method_to_channel_name(service_container.service.class, method_name.to_sym)
        puts "Registering service: #{channel}"
        store.subscribe(channel) do |message|
          if service_container.service.respond_to?(method_name.to_sym)
            begin
              service_container.service.send(method_name.to_sym, message)
            rescue => e
              puts "Kiyohime Error: #{e}"
              raise Kiyohime::Exceptions::SubscriberError.new(e.message, channel, message)
            end
          end
        end
      end
    end

    private

    # When the first series of services are registered via the registry, the deregister subscriber
    # is also registered, this is used to un-subscribe services
    def subscribe_deregister
      dereg_channel = channel_parser.parse_type_and_method_to_channel_name(self.class, :deregister)
      puts "Registering service: #{dereg_channel}"
      store.subscribe(dereg_channel) do |message|
        puts "Unsubscribing from channel #{message}"
        store.unsubscribe(message)
      end
    end

    # Initialisation of the registry within the scope of an EventMachine block
    def initialise_registry
      if hiredis
        @store = store.hiredis
      else
        @store = store.redis
      end
      subscribe_deregister
    end
  end
end
