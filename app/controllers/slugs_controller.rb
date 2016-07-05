class SlugsController < ApplicationController
  def show
    slug = Slug.includes(:resource).where(computed_slug: params[:slug_parts]).order(active: :desc, created_at: :desc).first
    object = slug.resource_type.downcase
    instance_variable_set("@#{object}", slug.resource)

    render "#{object.pluralize}/show"
  end
end