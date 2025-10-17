class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def current_admin
    @current_admin ||= AdminUser.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end
  helper_method :current_admin

  def authenticate_admin!
    unless current_admin
      redirect_to admin_login_path, alert: "ログインしてください"
    end
  end

  def admin_logged_in?
    !!current_admin
  end
  helper_method :admin_logged_in?
end
