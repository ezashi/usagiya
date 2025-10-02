class OrdersController < ApplicationController
  def new
    @order = Order.new
    @order.order_items.build
  end

  def confirm
    @order = Order.new(order_params)

    if @order.valid?
      render :confirm
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to root_path, notice: "ご注文ありがとうございました。確認メールをお送りしました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_name, :postal_code, :address, :phone, :email,
      :delivery_name, :delivery_postal_code, :delivery_address, :delivery_phone,
      :same_address, :payment_method, :delivery_date, :delivery_time,
      :wrapping_type, :notes,
      order_items_attributes: [ :id, :product_type, :quantity, :_destroy ]
    )
  end
end
