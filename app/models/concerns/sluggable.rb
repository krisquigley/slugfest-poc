require 'active_support/concern'

module Sluggable
  extend ActiveSupport::Concern

  module ClassMethods
    def slug_prefix
      Admin.first.product_slug
    end
  end

  def self.valid_slug_regex
    /\A[a-z0-9](?:[a-z0-9\-\_\/]*[a-z0-9])?\z/.freeze
  end

  included do
    extend ClassMethods

    has_many :slugs, as: :resource, autosave: true

    # ensure our slug is valid BEFORE trying to persist
    validates :slug, presence: true, format: Sluggable.valid_slug_regex

    # before persisting, write our external data
    before_save :update_slug_history, if: :slug_changed?
  end

  def slug_changed?
    new_record? || (slug != persisted_slug)
  end

  def slug=(value)
    @slug = value
  end

  def slug
    return @slug if defined?(@slug)
    @slug = persisted_slug
  end

  private

  def persisted_slug
    return @persisted_slug if defined?(@persisted_slug)
    @persisted_slug = slugs.find_by(active: true).try(:computed_slug)
  end

  def update_slug_history
    slug_created = with_transaction_returning_status do
      self.slugs.create_active_slug!(slug_prefix: self.class.slug_prefix, slug: slug, object: self)
    end

    unless slug_created
      self.errors.add(:slug, "could not be saved, already taken")
    end

    slug_created
  end
end