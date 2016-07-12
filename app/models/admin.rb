class Admin < ActiveRecord::Base
  after_save :update_prefixes

  private 
  
  def update_prefixes
    Slugs::UpdateSlugPrefixesForActiveSlugs.call(resource_type: 'product') if product_slug_changed?
  end
end