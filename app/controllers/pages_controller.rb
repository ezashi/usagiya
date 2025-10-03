class PagesController < ApplicationController
  def home
    # トップ画面用のデータを取得
    @featured_products = Product.published.featured.limit(10)
    @seasonal_products = Product.published.seasonal.limit(10)
    @recent_notices = Notice.published.limit(3)
  end

  def philosophy
    # 御菓子処うさぎやの想い
  end
end
