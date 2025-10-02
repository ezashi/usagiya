class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)

    if verify_recaptcha(model: @inquiry) && @inquiry.save
      redirect_to root_path, notice: "お問い合わせありがとうございました。"
    else
      flash.now[:alert] = "画像認証に失敗しました。" unless verify_recaptcha
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :phone, :email, :content)
  end

  def verify_recaptcha
    # For now, return true. In production, integrate with reCAPTCHA
    # gem 'recaptcha' を追加して実装してください
    true
  end
end
