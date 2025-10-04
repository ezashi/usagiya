class FeaturedProductsController < ApplicationController
  def index
    @products = Product.published.ordered_by_display
  end

  def show
    @product = Product.find(params[:id])
  end

  def featured
    @products = Product.published.featured
    # featured.html.erbを使用
  end

  def seasonal
    @products = Product.published.seasonal
    render :index
  end
end
