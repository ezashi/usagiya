class PagesController < ApplicationController
  def home
    # トップページに表示する商品を取得
    @featured_products = Product.visible.featured.ordered.limit(6)
    @all_products = Product.visible.ordered
  end
end
