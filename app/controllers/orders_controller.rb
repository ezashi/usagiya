class OrdersController < ApplicationController
  def new
    @order = Order.new
    # もちパイの各種類の商品を事前に構築
    Order::PRODUCT_PRICES.each_key do |product_type|
      @order.order_items.build(product_type: product_type, quantity: 0)
    end
  end

  def confirm
    @order = Order.new(order_params)

    # order_itemsの不要なレコード(quantity=0)を削除
    @order.order_items.each do |item|
      item.mark_for_destruction if item.quantity.to_i <= 0
    end

    if @order.valid?
      render :confirm
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to complete_orders_path, notice: "ご注文ありがとうございました。"
    else
      render :confirm, status: :unprocessable_entity
    end
  end

  def complete
    # 完了画面を表示
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
