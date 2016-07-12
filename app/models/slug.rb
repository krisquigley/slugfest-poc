class Slug < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  validates :computed_slug, uniqueness: true, presence: true, format: Sluggable.valid_slug_regex
end