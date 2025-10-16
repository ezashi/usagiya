class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  private

  def authenticate_admin!
    unless current_admin_user
      redirect_to admin_login_path, alert: "ログインしてください。"
    end
  end

  def current_admin_user
    return @current_admin_user if defined?(@current_admin_user)
    @current_admin_user = AdminUser.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end
  helper_method :current_admin_user

  def admin_logged_in?
    current_admin_user.present?
  end
  helper_method :admin_logged_in?

  def log_admin_activity(action, target = nil)
    Rails.logger.info "[Admin Activity] User: #{current_admin_user&.login_id}, Action: #{action}, Target: #{target}, Time: #{Time.current}"
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    redirect_to admin_root_path, alert: "指定されたレコードが見つかりませんでした。"
  end
end
