class ProductsController < ApplicationController
  before_action :find_product, only: [:view, :edit, :update]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    product = Product.create!(product_params)

    redirect_to action: :index
  end

  def edit
    # This is needed otherwise the computed slug is edited rather than the original
    @product.slug = @product.slugs.find_by(active: true).slug
  end

  def update
    @product.update!(product_params)
  
    redirect_to action: :index
  end

  def destroy
    @product.destroy

    redirect_to :index
  end

  private

  def find_product
    @product ||= Product.includes(:slugs).find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :slug)
  end
end