class Slugs::UpdateSluggableHistory
  def self.call(*args)
    new(*args).call
  end

  def initialize(slug_prefix:, resource:)
    @slug_prefix = slug_prefix
    @resource = resource
  end

  def call
    @resource.slugs.active.update_all(active: false) &&
    @resource.slugs.active.build(
      slug_prefix: @slug_prefix, 
      slug: @resource.slug, 
      computed_slug: @resource.computed_slug
    )
  end
end