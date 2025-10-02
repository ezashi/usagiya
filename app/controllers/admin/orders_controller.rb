class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
  end
end
