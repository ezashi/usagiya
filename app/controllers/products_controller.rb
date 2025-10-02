class ProductsController < ApplicationController
  def index
    @products = Product.all.recent
  end

  def show
    @product = Product.find(params[:id])
  end
end
