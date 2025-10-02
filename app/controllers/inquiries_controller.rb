class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)

    # reCAPTCHAが設定されている場合のみ検証
    if recaptcha_configured?
      if verify_recaptcha(model: @inquiry) && @inquiry.save
        redirect_to root_path, notice: "お問い合わせありがとうございました。確認メールをお送りしました。"
      else
        @inquiry.errors.add(:base, "画像認証に失敗しました。もう一度お試しください。") unless verify_recaptcha(model: @inquiry)
        render :new, status: :unprocessable_entity
      end
    else
      # reCAPTCHAが設定されていない場合はスキップ
      if @inquiry.save
        redirect_to root_path, notice: "お問い合わせありがとうございました。確認メールをお送りしました。"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :phone, :email, :content)
  end

  def recaptcha_configured?
    ENV["RECAPTCHA_SITE_KEY"].present? && ENV["RECAPTCHA_SECRET_KEY"].present?
  end
end
