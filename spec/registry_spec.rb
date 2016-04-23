require 'spec_helper'
require 'kiyohime/containers/service_registration'
require 'kiyohime/registry'
require 'factories/registries'
require 'mock_store'
require 'mock_pub_sub'
require 'services/another_service_with_generic_handler'
require 'services/service_with_bespoke_handler'
require 'services/service_with_generic_handler'
require 'services/service_with_no_handler'

describe Kiyohime::Registry do
  # EM::Hiredis.connect.pubsub
  let(:store)        { MockStore.new }
  let(:pubsub)       { MockPubSub.new(store) }
  subject(:registry) { Kiyohime::Registry.new('test registry', store, pubsub) }

  it 'should not register a service with no generic handler' do
    service = Services::ServiceWithNoHandler.new
    expect(registry.register(service)).to be_falsey
  end

  it 'should register a single service with a generic handler' do
    service = Services::ServiceWithGenericHandler.new
    expect(registry.register(service)).to be_truthy
  end

  it 'should track a service when it is registered' do
    service = Services::ServiceWithGenericHandler.new
    expect(registry.register(service)).to be_truthy
    expect(registry.registered?(service)).to be_truthy
  end

  it 'should not allow the same service to be registered twice' do
    service = Services::ServiceWithGenericHandler.new
    expect(registry.register(service)).to be_truthy
    expect(registry.register(service)).to be_falsey
  end

  it 'should not deregister a service which is not registered' do
    service = Services::ServiceWithGenericHandler.new
    expect(registry.deregister(service)).to be_falsey
  end

  it 'should deregister a single service with a generic handler if it is registered' do
    service = Services::ServiceWithGenericHandler.new
    expect(registry.register(service)).to be_truthy
    expect(registry.deregister(service)).to be_truthy
  end

  it 'should register services with bespoke handler' do
    service = Services::ServiceWithGenericHandler.new
    service_registration = Kiyohime::Containers::ServiceRegistration.new(service, :method1, :method2)
    expect(registry.register_container(service_registration)).to be_truthy
  end

  it 'should track the registration of services with bespoke handlers' do
    service = Services::ServiceWithGenericHandler.new
    service_registration = Kiyohime::Containers::ServiceRegistration.new(service, :method1, :method2)
    expect(registry.register_container(service_registration)).to be_truthy
    expect(registry.registered?(service, :method1)).to be_truthy
    expect(registry.registered?(service, :method2)).to be_truthy
  end
end
