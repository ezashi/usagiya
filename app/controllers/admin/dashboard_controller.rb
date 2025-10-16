class Admin::DashboardController < Admin::AdminController
  def index
    @products = Product.all
    @featured_count = Product.where(featured: true).count
    @seasonal_count = Product.where(seasonal: true).count
    @visible_count = Product.where(visible: true).count
  end
end
