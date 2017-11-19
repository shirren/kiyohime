# frozen_string_literal: true

require 'redis'
require 'kiyohime/stores/redis_store'
require 'kiyohime/publisher'

module Kiyohime
  # This helper can be mixed into classes which want to just simply open a Redis connection
  # and then publish a message
  module PublisherHelper
    # Create a redis publisher
    def publisher
      @redis_connection ||= Kiyohime::Stores::RedisStore.new.redis
      Kiyohime::Publisher.new(@redis_connection)
    end
  end
end
