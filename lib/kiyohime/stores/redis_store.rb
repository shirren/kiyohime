require 'em-hiredis'
require 'redis'

module Kiyohime
  module Stores
    # A rudimentary abstraction of the store which will advance over time no doubt
    class RedisStore
      def store
        Redis.new
      end

      def pubsub
        EM::Hiredis
      end
    end
  end
end
