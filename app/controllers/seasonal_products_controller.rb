class SeasonalProductsController < ApplicationController
  def index
    @products = Product.where(seasonal: true, visible: true)
                      .where.not(published_at: nil)
                      .order(seasonal_order: :asc)
  end
end
