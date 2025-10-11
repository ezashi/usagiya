class OrderMailer < ApplicationMailer
  default from: "noreply@usagiya-fukui.jp"

  # 顧客向け注文確認メール
  def customer_confirmation(order)
    @order = order
    mail(
      to: @order.email,
      subject: "【御菓子処うさぎや】ご注文ありがとうございます"
    )
  end

  # 管理者向け注文通知メール
  def admin_notification(order)
    @order = order
    # 管理者のメールアドレスは環境変数または設定ファイルから取得
    admin_email = ENV["ADMIN_EMAIL"] || "admin@usagiya-fukui.jp"

    mail(
      to: admin_email,
      subject: "【御菓子処うさぎや】新規注文が入りました"
    )
  end
end
