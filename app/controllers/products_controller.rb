class ProductsController < ApplicationController
  # おすすめ商品一覧
  def featured
    @products = Product.where(featured: true, visible: true)
    .where.not(published_at: nil)
    .order(featured_order: :asc)
  end

  # 季節限定商品一覧
  def seasonal
    @products = Product.where(seasonal: true, visible: true)
    .where.not(published_at: nil)
    .order(seasonal_order: :asc)
  end

  # 商品詳細
  def show
    @product = Product.find(params[:id])
  end
end
