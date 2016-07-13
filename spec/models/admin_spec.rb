require 'rails_helper'

RSpec.describe Admin do 
  describe "Updating a product prefix" do
    before(:each) do
      Product.destroy_all
      Admin.destroy_all
      admin = create(:admin)
      create_list(:product, 2)
      admin.update!(product_slug: 'whatevs')
    end
    
    it "should queue a worker" do
      expect(Slugs::UpdateSlugPrefixesForActiveSlugsWorker).to have_enqueued_job(resource_type: 'product', slug_prefix: 'whatevs')
    end
  end
end