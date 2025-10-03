class Admin::SessionsController < Devise::SessionsController
  # POST /admin/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)

    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)

      # ログイン成功時のメール通知
      AdminLoginMailer.successful_login(resource).deliver_later

      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  rescue
    # ログイン失敗時のメール通知
    if params[:admin_user] && params[:admin_user][:email].present?
      AdminLoginMailer.failed_login_attempt(params[:admin_user][:email]).deliver_later
    end

    # 通常のログイン失敗処理
    super
  end

  protected

  def after_sign_in_path_for(resource)
    admin_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_user_session_path
  end
end
