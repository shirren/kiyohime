class MockStore
  attr_reader :keys

  def initialize
    @keys = {}
  end

  def set(channel, value)
    keys[channel] = value
  end

  def publish(channel, message)
  end

  def subscribe(channel)
    set(channel, true)
    yield if block_given?
  end

  def unsubscribe(channel)
    keys.delete(channel)
  end
end
