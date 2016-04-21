require 'active_model'
require 'active_model/model'
# require 'em-synchrony'
require 'em-hiredis'
require 'kiyohime/parsers/channel_parser'
# require 'redis'

module Kiyohime
  # A registry is a listing of services which are accessible to a given microservice. It is
  # assume that a listed Microservice is always available
  class Registry
    include ActiveModel::Model

    attr_reader :name, :channel_parser, :redis

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
        redis = redis_connection
        services.each do |service|
          channel = channel_parser.parse_type_to_channel_name(service.class)
          redis.pubsub.subscribe(channel) do |message|
            # This approach uses a generic approach, so the service should implement
            # a generic method named handle which takes a single argument
            service.handle(message) if service.respond_to?(:handle)
          end
        end
      end
    end

    # A service should be able to register it's global interest in receiving all messages to a
    # channel name derived using the service name and method name. This unlike the generic register
    # method which assumes the service implements a particular interface
    def register_containers(*service_containers)
      EM.run do
        redis = redis_connection
        service_containers.each do |service_container|
          service_container.methods.each do |method_name|
            channel = channel_parser.parse_type_and_method_to_channel_name(service_container.service.class, method_name.to_sym)
            redis.pubsub.subscribe(channel) do |message|
              if service_container.service.respond_to?(method_name.to_sym)
                service_container.service.send(method_name.to_sym, message)
              end
            end
          end
        end
      end
    end

    private

    # Encapsulate connection to redis
    def redis_connection
      EM::Hiredis.connect
    end
  end
end
