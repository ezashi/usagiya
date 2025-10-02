class Admin::SessionsController < ApplicationController
  layout "admin"

  def new
    redirect_to admin_root_path if admin_logged_in?
  end

  def create
    admin_user = AdminUser.authenticate(params[:email], params[:password])

    if admin_user
      session[:admin_user_id] = admin_user.id
      redirect_to admin_root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "ログイン情報が登録されていません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_user_id] = nil
    redirect_to admin_login_path, notice: "ログアウトしました"
  end
end
