module Kiyohime
  module Exceptions
    # This error is used to signal when a subscriber throws an error
    class SubscriberError < StandardError

      attr_reader :message, :action, :data

      def initialize(message, action = nil, data = nil)
        @message = message
        @action = action
        @data = data
        super(message)
      end
    end
  end
end
