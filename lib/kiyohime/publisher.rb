require 'redis'
require 'kiyohime/parsers/channel_parser'

module Kiyohime
  # A publisher can be used to publish a message to a specific function. It also has the facility to
  # list the names of the available functions
  class Publisher
    attr_reader :store

    # Initialises the publisher by obtaining a Redis connection
    def initialize
      @store = connection
    end

    # Lists all the available functions/services, each name is unique
    def list
    end

    # A message can be published to a service/function, a message can be a simple type, or at
    # present a JSON compliant type
    def publish(service, message)
      if store
        puts "Published message: #{message} to service: #{service}" if store.publish(service, message)
      end
    end

    private

    # Retrieve the store connection
    def connection
      Redis.new
    end
  end
end
