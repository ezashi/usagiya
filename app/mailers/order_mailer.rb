class OrderMailer < ApplicationMailer
  default from: "noreply@usagiya-fukui.jp"

  # 顧客への確認メール
  def customer_confirmation(order)
    @order = order
    mail(
      to: @order.email,
      subject: "【御菓子処うさぎや】ご注文を承りました"
    )
  end

  # 管理者への通知メール
  def admin_notification(order)
    @order = order
    mail(
      to: "info@usagiya-fukui.jp",  # 実際の管理者メールアドレスに変更してください
      subject: "【新規注文】冷凍もちパイのご注文がありました"
    )
  end
end
