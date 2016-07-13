class Slugs::ComputeSlug
  def self.call(slug_prefix:, slug: )
    new(slug_prefix, slug).call
  end

  attr_accessor :slug_prefix, :slug

  def initialize(slug_prefix, slug)
    self.slug_prefix = slug_prefix
    self.slug          = slug
  end

  def call
    [slug_prefix, slug].map(&:presence).compact.join('/')
  end
end