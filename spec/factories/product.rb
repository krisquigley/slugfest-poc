require 'faker'

FactoryGirl.define do
  factory :product do
    sku { Faker::Hacker.abbreviation }
    slug { Faker::Lorem.word }
  end
end