require 'em-hiredis'
require 'redis'

module Kiyohime
  module Stores
    # A rudimentary abstraction of the store which will advance over time no doubt
    class RedisStore
      attr_reader :url

      def initialize(uri = nil)
        @url = uri || ENV['REDIS_URL'] || ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379/0'
      end

      def store
        Redis.new(url: url)
      end

      def pubsub
        EM::Hiredis.connect(url).pubsub
      end
    end
  end
end
