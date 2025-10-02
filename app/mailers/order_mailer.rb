class OrderMailer < ApplicationMailer
  default from: "noreply@usagiya-fukui.jp"

  def customer_confirmation(order)
    @order = order
    mail(
      to: @order.email,
      subject: "【うさぎや】ご注文ありがとうございます"
    )
  end

  def admin_notification(order)
    @order = order
    mail(
      to: ENV["ADMIN_EMAIL"] || "admin@usagiya-fukui.jp",
      subject: "【うさぎや】新規注文が入りました"
    )
  end
end
