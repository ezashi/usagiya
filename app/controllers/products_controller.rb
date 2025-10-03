# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.published.ordered_by_display
  end

  def show
    @product = Product.find(params[:id])
  end

  def featured
    @products = Product.published.featured
    render :index
  end

  def seasonal
    @products = Product.published.seasonal
    render :index
  end
end
