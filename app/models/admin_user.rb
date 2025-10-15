class AdminUser < ApplicationRecord
  # セキュアパスワード機能を使用
  has_secure_password

  # Validations
  validates :login_id,
    presence: { message: "管理者ユーザーIDを入力してください。" }

  validates :password,
    presence: { message: "パスワードを入力してください。" },
    length: {
      minimum: 7,
      message: "パスワードを7文字以上入力してください。"
    },
    if: -> { new_record? || !password.nil? }

  # 認証メソッド
  def self.authenticate(login_id, password)
    user = find_by(login_id: login_id)
    user&.authenticate(password)
  end
end
