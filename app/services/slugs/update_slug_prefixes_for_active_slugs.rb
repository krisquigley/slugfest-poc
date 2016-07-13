class Slugs::UpdateSlugPrefixesForActiveSlugs
  attr_accessor :resource_type, :slug_prefix, :slug_computer

  def self.call(resource_type:, slug_prefix:, slug_computer: nil)
    new(resource_type, slug_prefix, slug_computer).call
  end

  def initialize(resource_type, slug_prefix, slug_computer)
    self.resource_type = resource_type.capitalize
    self.slug_prefix   = slug_prefix
    self.slug_computer = slug_computer || Slugs::ComputeSlug
  end

  def call
    Slug.transaction do
      Slug.active_for_resource_type(resource_type).find_in_batches do |batch| 
        batch.each do |active_slug|
          active_slug.update!(active: false)
          generate_record(active_slug).save!
        end
      end
    end
  end

  private

  def generate_record(active_slug)
    active_slug.dup.tap { |s| s.assign_attributes(slug_params(s)) }
  end

  def slug_params(attributes)
    { 
      slug_prefix: slug_prefix, 
      active: true,
      computed_slug: slug_computer.call(slug_prefix: slug_prefix, slug: attributes.slug) 
    }
  end
end