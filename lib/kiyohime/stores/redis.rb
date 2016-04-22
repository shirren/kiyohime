require 'em-hiredis'
require 'redis'

module Kiyohime
  module Stores
    # A rudimentary abstraction of the store which will advance over time no doubt
    class Redis
      def create
        Redis.new
      end

      def create_async
        EM::Hiredis.connect.pubsub
      end
    end
  end
end
