# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kiyohime/version'

Gem::Specification.new do |spec|
  spec.name          = 'kiyohime'
  spec.version       = Kiyohime::VERSION
  spec.authors       = ['Shirren Premaratne']
  spec.email         = ['shirren@me.com']

  spec.summary       = 'Kiyohime is a library which provides a wrapper around Redis for pubsub.'
  spec.description   = 'Kiyohime is a library which provides a wrapper around Redis for pubsub.'
  spec.homepage      = 'http://github.com/shirren/kiyohime'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Add runtime depenencies here
  spec.add_runtime_dependency 'em-hiredis', '~> 0.3'
  spec.add_runtime_dependency 'redis', '~> 3.3'

  # Add development dependencies here
  spec.add_development_dependency 'byebug', '~> 8.2'
  spec.add_development_dependency 'factory_girl', '~> 4.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.39'
  spec.add_development_dependency 'simplecov', '~> 0.11'
end
