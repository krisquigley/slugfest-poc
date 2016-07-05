class Product < ActiveRecord::Base
  include Sluggable
  validates :sku, presence: true

  
end