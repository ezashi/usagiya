class PagesController < ApplicationController
  layout false, only: [ :home ]

  def home
    @featured_products = Product.published.featured.limit(10)
    @seasonal_products = Product.published.seasonal.limit(10)
    @recent_notices = Notice.published.limit(3)
  end

  def philosophy
  end
end
