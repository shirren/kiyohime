# frozen_string_literal: true

require 'redis'
require 'kiyohime/stores/redis_store'

module Kiyohime
  # A publisher can be used to publish a message to a specific function. It also has the facility to
  # list the names of the available functions
  class Publisher
    attr_reader :store

    # Initialises the publisher by obtaining a Redis connection
    def initialize(store = nil)
      @store = store || Kiyohime::Stores::RedisStore.new.redis
    end

    # A message can be published to a service/function, a message can be a simple type, or at
    # present a JSON compliant type
    def publish(service, message)
      if store
        puts "Published message: #{message} to service: #{service}" if store.publish(service, message)
      end
    end
  end
end
