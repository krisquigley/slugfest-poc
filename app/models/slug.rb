class Slug < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  before_validation :compute_slug
  validates :computed_slug, uniqueness: true, presence: true, format: Sluggable.valid_slug_regex

  def self.create_active_slug!(slug_prefix: , slug:)
    transaction do
      where(active: true).update_all(active: false)
      create!(slug_prefix: slug_prefix, slug: slug, active: true)
    end
  end

  private
  def compute_slug
    self.computed_slug = [slug_prefix, slug].map(&:presence).compact.join('/')
  end
end