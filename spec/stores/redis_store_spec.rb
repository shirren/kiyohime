require 'spec_helper'

describe Kiyohime::Stores::RedisStore do
  context 'with default connection' do
    let(:store) { Kiyohime::Stores::RedisStore.new }

    it 'should have a default uri' do
      expect(store.url).to eq('redis://127.0.0.1:6379/0')
    end

    it 'should be able to create a Redis store' do
      expect(store.redis).to_not be_nil
    end
  end

  context 'with custom connection' do
    let(:store) { Kiyohime::Stores::RedisStore.new('redis://rediscloud:sdfh467t@pub-redis.com:6379') }

    it 'should be able to take a custom url' do
      expect(store.url).to eq('redis://rediscloud:sdfh467t@pub-redis.com:6379')
    end

    it 'should be able to create a Redis store' do
      expect(store.redis).to_not be_nil
    end
  end
end
