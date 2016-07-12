require 'rails_helper'

RSpec.describe Admin do 
  describe "Updating a product prefix" do
    before(:each) do
      Product.destroy_all
      Admin.destroy_all
      admin = create(:admin)
      5.times do 
        create(:product)
      end
      admin.update!(product_slug: 'whatevs')
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