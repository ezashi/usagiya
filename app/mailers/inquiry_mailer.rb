class InquiryMailer < ApplicationMailer
  default from: "noreply@usagiya-fukui.jp"

  def customer_confirmation(inquiry)
    @inquiry = inquiry
    mail(
      to: @inquiry.email,
      subject: "【うさぎや】お問い合わせありがとうございます"
    )
  end

  def admin_notification(inquiry)
    @inquiry = inquiry
    mail(
      to: ENV["ADMIN_EMAIL"] || "admin@usagiya-fukui.jp",
      subject: "【うさぎや】新しいお問い合わせがあります"
    )
  end
end
