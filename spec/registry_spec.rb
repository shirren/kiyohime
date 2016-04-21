require 'spec_helper'
require 'kiyohime/containers/service_registration'
require 'kiyohime/registry'
require 'factories/registries'
require 'services/another_service_with_generic_handler'
require 'services/service_with_bespoke_handler'
require 'services/service_with_generic_handler'
require 'services/service_with_no_handler'

describe Kiyohime::Registry do
  subject(:registry) { Kiyohime::Registry.new('test registry') }

  # These have been set to skip because register is an evented blocking call
  skip 'should throw an error when a type with no generic handler registers itself' do
    service = Services::ServiceWithNoHandler.new
    registry.register(service)
  end

  # These have been set to skip because register is an evented blocking call
  skip 'should register a single service with a generic handler' do
    service = Services::ServiceWithGenericHandler.new
    registry.register(service)
  end

  # These have been set to skip because register is an evented blocking call
  skip 'should deregister a single service with a generic handler' do
    service = Services::ServiceWithGenericHandler.new
    registry.deregister(service)
  end

  # These have been set to skip because register is an evented blocking call
  skip 'should register multiple services with a generic handler' do
    service1 = Services::ServiceWithGenericHandler.new
    service2 = Services::AnotherServiceWithGenericHandler.new
    registry.register(service1, service2)
  end

  # These have been set to skip because register is an evented blocking call
  skip 'should register multiple services with bespoke handlers' do
    service1 = Services::ServiceWithBespokeHandler.new
    service_registration1 = Kiyohime::Containers::ServiceRegistration.new(service1, :method1, :method2)
    service_registration2 = Kiyohime::Containers::ServiceRegistration.new(service1, :method3)
    registry.register_containers(service_registration1, service_registration2)
  end
end
