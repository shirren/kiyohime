# frozen_string_literal: true

module Kiyohime
  module Containers
    # Services can be registered via this container. It is principally used for services
    # which add bespoke methods to the registry
    class ServiceRegistration
      attr_reader :service, :methods

      def initialize(service, *methods)
        @service = service
        @methods = methods
      end
    end
  end
end
