class AdminUser < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: { message: "管理者ユーザーIDを入力してください" },
                    uniqueness: { message: "このユーザーIDは既に使用されています" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "正しいメールアドレス形式で入力してください" }
  validates :password, presence: { message: "パスワードを入力してください" },
                       length: { minimum: 7, message: "パスワードは7文字以上で入力してください" },
                       on: :create
  validates :password, length: { minimum: 7, message: "パスワードは7文字以上で入力してください" },
                       allow_blank: true,
                       on: :update

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  # Authentication
  def self.authenticate(email, password)
    user = find_by(email: email)

    if user&.authenticate(password)
      AdminLoginMailer.successful_login(user).deliver_later
      user
    else
      AdminLoginMailer.failed_login_attempt(email).deliver_later
      nil
    end
  end

  private

  def set_defaults
    # Set any default values if needed
  end
end
