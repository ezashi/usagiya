class Inquiry < ApplicationRecord
  # Validations
  validates :name, presence: { message: "お名前を入力してください" }
  validates :phone, presence: { message: "電話番号を入力してください" },
                    format: { with: /\A\d{10,11}\z/, message: "電話番号は10桁または11桁の数字で入力してください" }
  validates :email, presence: { message: "E-MAILを入力してください" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "正しいメールアドレスを入力してください" }
  validates :content, presence: { message: "お問い合わせ内容を入力してください" }

  # Callbacks
  after_create :send_inquiry_notifications

  private

  def send_inquiry_notifications
    InquiryMailer.customer_confirmation(self).deliver_later
    InquiryMailer.admin_notification(self).deliver_later
  end
end
