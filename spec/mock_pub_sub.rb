class MockPubSub
  attr_reader :store

  def initialize(store)
    @store = store
  end

  def connect
    self
  end

  def hiredis
    self
  end

  def subscribe(channel)
    store.set(channel, true)
    yield if block_given?
  end

  def unsubscribe(channel)
    store.keys.delete(channel)
  end
end
