module Kiyohime
  module Exceptions
    # This error is used to signal a service without a generic handler
    class UnsupportedInterface < StandardError
    end
  end
end
