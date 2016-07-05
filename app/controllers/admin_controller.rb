class AdminController < ApplicationController
  def edit
    @admin = Admin.first
  end

  def update
  end
end