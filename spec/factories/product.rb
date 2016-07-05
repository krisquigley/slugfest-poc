require 'faker'

FactoryGirl.define do
  factory :product do
    sku { Faker::Hacker.abbreviation }
    slug { Faker::Hacker.noun }
  end
end