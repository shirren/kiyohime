# Kiyohime

Kiyohime is a microservice framework written in Ruby. In Ruby microservices are traditionally written as RESTful services using established frameworks (e.g. Rails, Sinatra, Grape etc). At present there appears to be no elegant microservice framework for the Ruby language that works on a publish/subscribe model. Kiyohime is an attempt to fill this gap.

**Please note that this library is not production ready, we will inform you when it is**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kiyohime'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kiyohime

## Usage

Kiyohime works by providing a registry. The registry is why services register their interest to receive messages from publishers. The simplest subscriber can be a PORO (plain old ruby object) which implements a method named handle. So for example we could write the following service;

```ruby
class MySubscriber
  def handle(message)
    puts "My subscriber handle invoke: #{message}"
  end
end
```

To register this service and it's method as a subscriber we first need to create an instance of the Registry which we can then use to register our MySubscriber service. The registry is currently powered by Redis. The example below demonstrates how to use the registry;

```ruby
service = MySubscriber.new
store = Kiyohime::Stores::RedisStore.new
registry = Kiyohime::Registry.new('My Registry', store)
registry.register_services(service)
```

Runnin the code above should print the following statements to the console;

```
Registering service: kiyohime.registry.deregister
Registering service: mysubscriber
```

Now what we have is a channel named 'mysubscriber' to which we can publish a message. To publish a message one can use Kiyohime, but as we use Redis, a message can be published to our Ruby service in a platform and language agnostic manner. So for example if we have the Redis CLI installed we could send a message to our service using the following command;

```
redis-cli publish "mysubscriber" "test message"
```

If you would like to send/publish a message using Kiyohime we can do use as shown below;

```ruby
publisher = Kiyohime::Publisher.new
publisher.publish('mysubscriber', 'another test message')
```

It is important to note that both the publisher and the registry can take a custom Redis object if required. So what if want to write a more sophisticated service, instead of a simple service with the prescriptive interface with a handle method? Well this is certainly possible. Suppose we have the following service definition;

```ruby
class MyComplexSubscriber
  def method1(message)
    puts "My subscriber method1 invoke: #{message}"
  end

  def method2(hash_arg)
    puts "My subscriber method2 invoke: #{hash_arg[:key1]}"
  end

  def method3(hash_arg)
    puts "My subscriber method3 invoke: #{hash_arg[:key1]}"
  end
end
```

`MyComplexSubscriber` has 3 methods, and I'd like to register method1 and method2 only as subcribers. To do this we need to use a class called the service container. The code below illustrates how to use Kiyohime service container to register method1 and method2 from MyComplexSubscriber.

```ruby
my_complex_service = MyComplexSubscriber.new
service_container = Kiyohime::Containers::ServiceRegistration.new(my_complex_service, :method1, :method2)
store = Kiyohime::Stores::RedisStore.new
registry = Kiyohime::Registry.new('My Registry', store)
registry.register_containers(service_container)
```

Running the code above should print the following to your console;

```
Registering service: kiyohime.registry.deregister
Registering service: mycomplexsubscriber.method1
Registering service: mycomplexsubscriber.method2
```

If the statements do not appear in the order show above do not worry, as long as they appear your service subscribers have been setup correctly. Note how `method3` is not listed. We can see that when we created the `ServiceRegistration` we are also specifying which methods to setup as subscribers only.

Our examples use simple datatypes and collection types in the example. At present this is all we have tested, but in theory complex types can be passed in the message as long as the size of the complex type does not exceed 256kb, the default limit in Redis.

The methods `register_async` and `register_containers_async` can also take an array of subscribers. So for example if I wanted to register both my `MySubscriber` and `MyComplexSubscriber` in one go? Well the code sample below illustrates how this can be achieved;

```ruby
service = MySubscriber.new
service_container1 = Kiyohime::Containers::ServiceRegistration.new(service, :handle)
my_complex_service = MyComplexSubscriber.new
service_container2 = Kiyohime::Containers::ServiceRegistration.new(my_complex_service, :method1, :method2)
store = Kiyohime::Stores::RedisStore.new
registry = Kiyohime::Registry.new('My Registry', store)
registry.register_containers_async(service_container1, service_container2)
```

## Development

After checking out the repo, run `rspec spec` to run the specs. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shirren/kiyohime. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

