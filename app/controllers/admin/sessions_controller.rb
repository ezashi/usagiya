class Admin::SessionsController < ApplicationController
  layout false  # レイアウトを使用しない

  def index
    # すでにログイン済みの場合はダッシュボードへリダイレクト
    if admin_logged_in?
      redirect_to admin_dashboard_path
      nil
    end
  end

  def create
    # バリデーション
    @errors = []

    if params[:login_id].blank?
      @errors << "管理者ユーザーIDを入力してください"
    end

    if params[:password].blank?
      @errors << "パスワードを入力してください"
    elsif params[:password].length < 7
      @errors << "パスワードは7文字以上入力してください"
    end

    # バリデーションエラーがあれば再表示
    if @errors.any?
      flash.now[:alert] = @errors
      render :index, status: :unprocessable_entity
      return
    end

    # ユーザー認証
    admin = AdminUser.find_by(login_id: params[:login_id])

    if admin.nil?
      @errors << "ユーザー情報が登録されていません"
      flash.now[:alert] = @errors
      render :index, status: :unprocessable_entity
      return
    end

    if admin.authenticate(params[:password])
      session[:admin_user_id] = admin.id

      # ログイン成功通知メール（オプション）
      # AdminMailer.login_notification(admin).deliver_later

      redirect_to admin_dashboard_path, notice: "ログインしました"
    else
      @errors << "ログインIDまたはパスワードが正しくありません"

      # ログイン失敗通知メール（オプション）
      # AdminMailer.failed_login_attempt(params[:login_id]).deliver_later

      flash.now[:alert] = @errors
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_user_id)
    @current_admin = nil
    redirect_to admin_login_path, notice: "ログアウトしました"
  end
end
