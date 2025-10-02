class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin_login

  private

  def require_admin_login
    unless admin_logged_in?
      redirect_to admin_login_path, alert: "ログインしてください"
    end
  end
end
