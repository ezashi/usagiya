# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      # 注文者への確認メール送信
      # OrderMailer.customer_confirmation(@order).deliver_later

      # 店舗への通知メール送信
      # OrderMailer.shop_notification(@order).deliver_later

      redirect_to complete_orders_path, notice: "ご注文ありがとうございます。確認メールをお送りしました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def complete
    # 注文完了ページ
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_name,
      :customer_postal_code,
      :customer_address,
      :customer_phone,
      :customer_email,
      :shipping_type,
      :shipping_name,
      :shipping_postal_code,
      :shipping_address,
      :shipping_phone,
      :payment_method,
      :delivery_date,
      :delivery_time,
      :wrapping,
      :notes,
      products: {}
    )
  end
end
