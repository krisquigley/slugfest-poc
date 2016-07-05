require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:all) do
    create(:admin)
  end

  describe "Creating a product" do
    subject { create(:product) }

    it "should be valid" do
      expect(subject).to be_valid
      expect(subject.slugs).to_not be_empty
    end

    context "with different valid slug cases" do 
      it "should be valid" do
        product = create(:product, slug: "this-and-this")
        expect(product).to be_valid
        expect(product.slugs).to_not be_empty
      end

      it "should be valid" do
        product = create(:product, slug: "this_and_this")
        expect(product).to be_valid
        expect(product.slugs).to_not be_empty
      end      

      it "should be valid" do
        product = create(:product, slug: "this/and/this")
        expect(product).to be_valid
        expect(product.slugs).to_not be_empty
      end  
    end

    context "with different invalid slug cases" do
      it "should not be valid" do
        product = build(:product, slug: "_this_and_this")
        expect(product).to_not be_valid
      end  

      it "should not be valid" do
        product = build(:product, slug: "/this_and_this")
        expect(product).to_not be_valid
      end

      it "should not be valid" do
        product = build(:product, slug: "this_and_this_")
        expect(product).to_not be_valid
      end

      it "should not be valid" do
        product = build(:product, slug: "this_and_this/")
        expect(product).to_not be_valid
      end

      it "should not be valid" do
        product = build(:product, slug: "tHis/aNd/thIs")
        expect(product).to_not be_valid
      end
    end
  end

  describe "Updating a product sku" do
    subject { create(:product) }

    before do
      subject.update!(sku: "123abc")
    end

    it "should be valid" do
      expect(subject).to be_valid
      expect(subject.slugs).to_not be_empty
    end
  end

  describe "Updating a product slug" do
    subject { create(:product) }

    before do
      subject.update!(slug: "123abc")
    end

    it "should be valid" do
      expect(subject).to be_valid
    end

    it "should be valid" do
      expect(subject.slugs.count).to eq 2
    end

    it "should be valid" do
      active_slug = subject.slugs.find_by(active: true)
      expect(active_slug.computed_slug).to eq "#{Product.slug_prefix}/#{active_slug.slug}"
      
    end

    it "should be valid" do
      active_slug = subject.slugs.find_by(active: true)
      expect(subject.slugs.find_by(active: false).computed_slug).to_not eq "#{Product.slug_prefix}/#{active_slug.slug}"
    end

    context "with an already taken slug" do
      it "should be invalid" do
        product = create(:product, slug: subject.slugs.find_by(active: true).slug)

        expect(product).to_not be_valid
      end
    end
  end
end