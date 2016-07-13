require 'rails_helper'

RSpec.describe "Sluggable" do
  before(:all) do
    create(:admin)
  end

  describe "Creating a product" do
    subject { create(:product) }

    context "with different valid slug cases" do 
      it "should be valid" do
        product = create(:product, slug: "this-and-this")
        expect(product).to be_valid
        expect(product.slugs).to_not be_empty
      end
    end

    context "with a snake_case_slug" do
      it "should be valid" do
        product = create(:product, slug: "this_and_this")
        expect(product).to be_valid
        expect(product.slugs).to_not be_empty
      end      
    end

    context "with a slug/containing/folders" do
      it "should be valid" do
        product = create(:product, slug: "this/and/this")
        expect(product).to be_valid
        expect(product.slugs).to_not be_empty
      end  
    end

    context "with a leading snake_case_slug" do
      it "should not be valid" do
        product = build(:product, slug: "_this_and_this")
        expect(product).to_not be_valid
      end  
    end

    context "with a slug/containing/a/starting/folder" do
      it "should not be valid" do
        product = build(:product, slug: "/this_and_this")
        expect(product).to_not be_valid
      end
    end

    context "with a trailing snake_case_slug" do
      it "should not be valid" do
        product = build(:product, slug: "this_and_this_")
        expect(product).to_not be_valid
      end
    end

    context "with a slug/ending/with/a/folder" do
      it "should not be valid" do
        product = build(:product, slug: "this_and_this/")
        expect(product).to_not be_valid
      end
    end

    context "with uppercase characters" do
      it "should not be valid" do
        product = build(:product, slug: "tHis/aNd/thIs")
        expect(product).to_not be_valid
      end
    end
  end

  describe "Updating a product sku" do
    subject { create(:product) }

    before do
      subject.update!(sku: "1234abc")
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
      active_slug = subject.slugs.active.first
      expect(active_slug.computed_slug).to eq "#{Product.slug_prefix}/#{active_slug.slug}"
    end

    it "should be valid" do
      active_slug = subject.slugs.active.first
      expect(subject.slugs.inactive.first.computed_slug).to_not eq "#{Product.slug_prefix}/#{active_slug.slug}"
    end

    context "with an already taken slug" do
      it "should be invalid" do
        product = create(:product, slug: subject.slugs.active.first.slug)

        expect(product).to_not be_valid
      end
    end
  end
end