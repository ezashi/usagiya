class Admin::DashboardController < ApplicationController
  def index
    @total_products = Product.count
    @visible_products = Product.visible.count
    @featured_products = Product.featured.count
  end
end
