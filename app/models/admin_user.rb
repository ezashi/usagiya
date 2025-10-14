class AdminUser < ApplicationRecord
  # セキュアパスワード機能を使用
  has_secure_password

  # Validations
  validates :login_id, presence: true, uniqueness: true
  validates :password, length: { minimum: 7 }, if: -> { new_record? || !password.nil? }

  # 認証メソッド
  def self.authenticate(login_id, password)
    user = find_by(login_id: login_id)
    user&.authenticate(password)
  end
end
