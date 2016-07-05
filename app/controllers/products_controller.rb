class ProductsController < ApplicationController
  before_action :find_product, only: [:view, :edit]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    product = Product.find_or_create_by!(product_params)

    redirect_to action: :index
  end

  def edit
  end

  def update
    @product.update!(product_params)
  
    redirect_to @product
  end

  def destroy
    @product.destroy

    redirect_to :index
  end

  private

  def find_product
    @product ||= Product.find(params[:id]).includes(:slugs)
  end

  def product_params
    params.require(:product).permit(:sku, :slug)
  end
end