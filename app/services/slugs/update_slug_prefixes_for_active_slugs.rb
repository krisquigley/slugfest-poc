class Slugs::UpdateSlugPrefixesForActiveSlugs
  attr_accessor :resource_type

  def self.call(resource_type:)
    new(resource_type).call
  end

  def initialize(resource_type)
    self.resource_type = resource_type.capitalize
  end

  def call
    Slug.transaction do
      active_slugs = Slug.where(resource_type: resource_type, active: true)
      active_slugs.each do |active_slug|
        active_slug.update!(active: false)
        generated_record = generate_record(active_slug)
        Slug.create!(generated_record)
      end
    end
  end

  private

  def generate_record(active_slug)
    active_slug.attributes
               .slice("slug", "resource_id", "resource_type")
               .merge(slug_params(active_slug.slug))
  end

  def slug_params(slug)
    { 
      slug_prefix: resource_type.constantize.slug_prefix, 
      computed_slug: Slugs::ComputeSlug.call(resource_type: resource_type, slug: slug) 
    }
  end
end