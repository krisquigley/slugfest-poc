class Admin < ActiveRecord::Base
  after_save :update_active_slug_prefixes, if: -> { product_slug_changed? }

  private 
  
  def update_active_slug_prefixes
    Slugs::UpdateSlugPrefixesForActiveSlugsWorker.perform_async(
      resource_type: 'product', slug_prefix: Product.slug_prefix
    )
  end
end