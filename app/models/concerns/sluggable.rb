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

    has_many :slugs, as: :resource, validate: true

    # ensure our slug is valid BEFORE trying to persist
    validates :slug, presence: true, format: Sluggable.valid_slug_regex

    # before persisting, write our external data
    before_save :update_slug_history, if: :slug_changed?
  end

  def slug_changed?
    new_record? || (computed_slug != persisted_slug)
  end

  def slug=(value)
    @slug = value
  end

  def slug
    @slug ||= persisted_slug
  end

  def computed_slug 
    Slugs::ComputeSlug.call(slug_prefix: self.class.slug_prefix, slug: slug)
  end

  private

  def persisted_slug
    @persisted_slug = slugs.find_by(active: true).try(:computed_slug)
  end

  def update_slug_history
    unless Slugs::UpdateSluggableHistory.call(slug_prefix: self.class.slug_prefix, resource: self)
      self.errors.add(:slug, 'already taken')
      throw :abort # Rails 5 only
      raise ActiveRecord::Rollback
    end
  end
end