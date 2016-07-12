FactoryGirl.define do
  factory :product do
    sku { SecureRandom.uuid }
    slug { SecureRandom.uuid }
  end
end