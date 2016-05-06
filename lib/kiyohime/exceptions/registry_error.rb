module Kiyohime
  module Exceptions
    # This error is used to signal when the registry has an issue
    class RegistryError < StandardError

      attr_reader :message

      def initialize(message)
        @message = message
        super(message)
      end
    end
  end
end
