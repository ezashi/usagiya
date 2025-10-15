class Admin::DashboardController < Admin::BaseController
  def index
    @total_products = Product.count
    @visible_products = Product.where(visible: true).count
    @featured_products = Product.where(featured: true).count
  end
end
