class Admin::SessionsController < ApplicationController
  layout "application"
  skip_before_action :require_admin_login, only: [ :new, :create ]

  # GET /admin/login
  def new
    redirect_to admin_root_path if admin_logged_in?
  end

  # POST /admin/login
  def create
    login_id = params[:login_id]
    password = params[:password]

    admin_user = AdminUser.authenticate(login_id, password)

    if admin_user
      # ログイン成功
      session[:admin_user_id] = admin_user.id

      # ログイン成功のメール通知
      AdminLoginMailer.successful_login(admin_user).deliver_later

      redirect_to admin_root_path, notice: "ログインしました"
    else
      # ログイン失敗
      # ログイン失敗のメール通知
      AdminLoginMailer.failed_login_attempt(login_id).deliver_later if login_id.present?

      flash.now[:alert] = "ログイン情報が正しくありません"
      render :new
    end
  end

  # DELETE /admin/logout
  def destroy
    session[:admin_user_id] = nil
    redirect_to admin_login_path, notice: "ログアウトしました"
  end

  private

  def require_admin_login
    # このコントローラーではスキップされるので空実装
  end
end
