class Slugs::ComputeSlug
  def self.call(resource_type:, slug: )
    new(resource_type, slug).call
  end

  attr_accessor :resource_type, :slug

  def initialize(resource_type, slug)
    self.resource_type = resource_type
    self.slug          = slug
  end

  def call
    [resource_type.constantize.slug_prefix, slug].map(&:presence).compact.join('/')
  end
end