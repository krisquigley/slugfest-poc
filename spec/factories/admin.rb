require 'faker'

FactoryGirl.define do
  factory :admin do
    product_slug { Faker::Hacker.noun }
  end
end