class Slug < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  validates :computed_slug, uniqueness: true, presence: true, format: Sluggable.valid_slug_regex

  def self.create_active_slug!(slug_prefix:, slug:, object:)
    transaction do
      where(active: true).update_all(active: false)
      object.slugs.build(slug_prefix: slug_prefix, slug: slug, active: true, computed_slug: compute_slug(slug_prefix, slug))
    end
  end

  private

  def self.compute_slug(slug_prefix, slug)
    [slug_prefix, slug].map(&:presence).compact.join('/')
  end
end