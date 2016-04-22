$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'byebug'
require 'factory_girl'
require 'kiyohime'
require 'simplecov'

SimpleCov.start do
  add_filter '/examples/'
  add_filter '/spec/services/'
  add_filter '/bin/'
end

# Dir['spec/factories/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  # So all FactoryGirl methods do not need to be prefaced with FactoryGirl
  config.include FactoryGirl::Syntax::Methods
end
