require 'faker'

FactoryGirl.define do
  factory :admin do
    product_slug { Faker::Lorem.word }
  end
end