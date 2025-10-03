class AdminUser < ApplicationRecord
  # Devise modules
  devise :database_authenticatable,
         :rememberable,
         :trackable,
         :validatable

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 7 }, if: :password_required?

  # Callbacks
  after_create :send_login_notification

  private

  def send_login_notification
    AdminLoginMailer.successful_login(self).deliver_later
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
