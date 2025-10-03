class ProductsController < ApplicationController
  def index
    @products = Product.visible.ordered
  end

  def show
    @product = Product.find(params[:id])
  end

  # おすすめ商品ページ
  def featured
    @featured_products = Product.visible.featured.ordered
  end
end
