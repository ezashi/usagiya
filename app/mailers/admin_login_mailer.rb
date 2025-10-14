class AdminLoginMailer < ApplicationMailer
  default from: "noreply@usagiya-fukui.jp"

  def successful_login(admin_user)
    @admin_user = admin_user
    @login_time = Time.current
    mail(
      to: ENV["ADMIN_EMAIL"] || "admin@usagiya-fukui.jp",
      subject: "【うさぎや】管理者ページに新たにログインがありました"
    )
  end

  def failed_login_attempt(login_id)
    @login_id = login_id
    @attempt_time = Time.current
    mail(
      to: ENV["ADMIN_EMAIL"] || "admin@usagiya-fukui.jp",
      subject: "【うさぎや】管理者ページに誤ったログイン情報でログインしようとしたユーザーがいます"
    )
  end
end
