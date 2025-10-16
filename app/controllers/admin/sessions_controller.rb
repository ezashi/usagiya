class Admin::SessionsController < ApplicationController
  layout "application"

  # GET /admin/login
  def index
    redirect_to admin_root_path if admin_logged_in?
  end

  # POST /admin/login
  def create
    login_id = params[:login_id]
    password = params[:password]

    # バリデーションチェック
    errors = []
    errors << "管理者ユーザーIDを入力してください。" if login_id.blank?
    errors << "パスワードを入力してください。" if password.blank?

    if password.present? && password.length < 7
      errors << "パスワードを7文字以上入力してください。"
    end

    if errors.any?
      flash.now[:alert] = errors.join("<br>").html_safe
      render :index, status: :unprocessable_entity
      return
    end

    # 認証チェック
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

      flash.now[:alert] = "ログイン情報が登録されていません。"
      render :index, status: :unprocessable_entity
    end
  end

  # DELETE /admin/logout
  def destroy
    session[:admin_user_id] = nil
    redirect_to admin_login_path, notice: "ログアウトしました"
  end
end
