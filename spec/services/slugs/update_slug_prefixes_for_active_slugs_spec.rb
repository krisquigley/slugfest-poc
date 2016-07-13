require 'rails_helper'

RSpec.describe Slugs::UpdateSlugPrefixesForActiveSlugs, :aggregate_failures do
  describe "Updating a product prefix" do
    before(:all) do
      Admin.destroy_all
      Product.destroy_all
      admin = create(:admin)
      create_list(:product, 2)
      admin.update!(product_slug: 'whatevs')
      
      Slugs::UpdateSlugPrefixesForActiveSlugs.call(resource_type: 'product', slug_prefix: 'whatevs')
    end

    it "should update all affected resources" do
      Product.all.each do |row|
        expect(row.slugs.count).to eq 2
      end
    end

    it "should not change the first slug" do
      Product.all.each do |row|
        expect(row.slugs.find_by(active: false).slug_prefix).to_not eq "whatevs"
      end
    end

    it "should add a new slug and update the prefix" do
      Product.all.each do |row|
        expect(row.slugs.find_by(active: true).slug_prefix).to eq "whatevs"
      end
    end
  end
end