class Slug < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  validates :resource, presence: true
  validates :computed_slug, uniqueness: true, presence: true, format: Sluggable.valid_slug_regex

  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.active_for_resource_type(resource_type)
    active.where(resource_type: resource_type)
  end
end