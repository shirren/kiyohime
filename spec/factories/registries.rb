require 'factory_girl'
require 'kiyohime/registry'

FactoryGirl.define do
  factory :registry, class: Kiyohime::Registry do
    name 'Standard registry'
  end
end
