require 'em-hiredis'
require 'kiyohime/parsers/channel_parser'

module Kiyohime
  # A registry is a listing of services which are accessible to a given microservice. It is
  # assume that a listed Microservice is always available
  class Registry
    attr_reader :name, :channel_parser

    # A registry should be provided with a name
    def initialize(name)
      @name = name
      @channel_parser = Kiyohime::Parsers::ChannelParser.new
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # particular channel, this means, the object must define a generic handler named handle. Multiple
    # services are registered in a single go using an evented publish subscribe approach
    def register(*services)
      EM.run do
        store = connection
        services.each do |service|
          channel = channel_parser.parse_type_to_channel_name(service.class)
          puts "Registering service: #{channel}"
          store.subscribe(channel) do |message|
            # This approach uses a generic approach, so the service should implement
            # a generic method named handle which takes a single argument
            service.handle(message) if service.respond_to?(:handle)
          end
        end
        subscribe_deregister(store)
      end
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # channel name derived using the service name and method name. This unlike the generic register
    # method which assumes the service implements a particular interface
    def register_containers(*service_containers)
      EM.run do
        store = connection
        service_containers.each do |service_container|
          service_container.methods.each do |method_name|
            channel = channel_parser.parse_type_and_method_to_channel_name(service_container.service.class, method_name.to_sym)
            puts "Registering service: #{channel}"
            store.subscribe(channel) do |message|
              if service_container.service.respond_to?(method_name.to_sym)
                service_container.service.send(method_name.to_sym, message)
              end
            end
          end
          subscribe_deregister(store)
        end
      end
    end

    private

    # Registers the deregister subscriber which uses the private function deregister to remove listeners
    def subscribe_deregister(store)
      dereg_channel = channel_parser.parse_type_and_method_to_channel_name(self.class, :deregister)
      puts "Registering service: #{dereg_channel}"
      store.subscribe(dereg_channel) do |message|
        deregister(store, message)
      end
    end

    # A service which is registered, can be deregistered, meaning it will no longer subscribe to messages. Once again a
    # generic service or a service in a container can be deregistered
    def deregister(store, channel)
      puts "Unsubscribing #{channel}"
      store.unsubscribe(channel)
    end

    # Retrieve the store connection
    def connection
      EM::Hiredis.connect.pubsub
    end
  end
end
