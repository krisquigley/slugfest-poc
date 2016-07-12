class AdminController < ApplicationController
  def edit
    @admin = Admin.first
  end

  def update
    Admin.first.update!(admin_params)

    redirect_to action: :edit, id: Admin.first.id  
  end

  private

  def admin_params
    params.require(:admin).permit(:product_slug)
  end
end