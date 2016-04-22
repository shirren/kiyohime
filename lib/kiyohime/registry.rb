require 'kiyohime/parsers/channel_parser'

module Kiyohime
  # A registry is a listing of services/functions which are accessible via a publish/subscribe paradigm. This
  # services/functions are accessible through the Publisher
  class Registry
    attr_reader :name, :channel_parser, :store

    # A registry should be provided with a name
    def initialize(name, store)
      @name = name
      @store = store
      @channel_parser = Kiyohime::Parsers::ChannelParser.new
      subscribe_deregister
    end

    # Asynchronous registration of services using the generic register functiob
    def register_async(*services)
      EM.run do
        # Convert the underlying store into one which supports evented calls
        @store = store.create_async
        services.each { |service| register(service) }
      end
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # particular channel, this means, the object must define a generic handler named handle. Multiple
    # services are registered in a single go using an evented publish subscribe approach
    def register(service)
      channel = channel_parser.parse_type_to_channel_name(service.class)
      unless store.keys.include?(channel)
        puts "Registering service: #{channel}"
        if service.respond_to?(:handle)
          store.subscribe(channel) do |message|
            # This approach uses a generic approach, so the service should implement
            # a generic method named handle which takes a single argument
            service.handle(message)
          end
          return true
        end
      end
      false
    end

    # Tell's the caller if a particular generic service or service function is registered
    def registered?(service, method = nil)
      channel = if method.nil?
                  channel_parser.parse_type_to_channel_name(service.class)
                else
                  channel_parser.parse_type_and_method_to_channel_name(service.class, method.to_sym)
                end
      store.keys.include?(channel)
    end

    # Asynchornous registration of multiple services via a service container. The service container
    # defines the service and the methods on the service to register
    def register_containers_async(*service_containers)
      EM.run do
        # Convert the underlying store into one which supports evented calls
        @store = store.create_async
        service_containers.each { |service| register_container(service_container) }
      end
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # channel name derived using the service name and method name. This unlike the generic register
    # method which assumes the service implements a particular interface
    def register_container(service_container)
      service_container.methods.each do |method_name|
        channel = channel_parser.parse_type_and_method_to_channel_name(service_container.service.class, method_name.to_sym)
        if !store.keys.include?(channel)
          store.set(channel, true)
          puts "Registering service: #{channel}"
          store.subscribe(channel) do |message|
            if service_container.service.respond_to?(method_name.to_sym)
              service_container.service.send(method_name.to_sym, message)
            end
          end
        else
          return false
        end
      end
      true
    end

    # A service which is registered, can be deregistered, meaning it will no longer subscribe to messages. Once again a
    # generic service or a service in a container can be deregistered
    def deregister(service)
      channel = channel_parser.parse_type_to_channel_name(service.class)
      puts "Unsubscribing #{channel}"
      store.unsubscribe(channel)
    end

    private

    # Registers the deregister subscriber which uses the private function deregister to remove listeners
    def subscribe_deregister
      dereg_channel = channel_parser.parse_type_and_method_to_channel_name(self.class, :deregister)
      store.set(dereg_channel, true) unless store.keys.include?(dereg_channel)
      puts "Registering service: #{dereg_channel}"
      store.subscribe(dereg_channel) do |message|
        puts "Unsubscribing #{message}"
        store.unsubscribe(message)
      end
    end
  end
end
