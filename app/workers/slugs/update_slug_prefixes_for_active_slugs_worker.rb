class Slugs::UpdateSlugPrefixesForActiveSlugsWorker
  include Sidekiq::Worker

  def perform(resource_type:, slug_prefix:)
    Slugs::UpdateSlugPrefixesForActiveSlugs.call(resource_type: resource_type, slug_prefix: slug_prefix)
  end
end