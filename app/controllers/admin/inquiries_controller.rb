class Admin::InquiriesController < Admin::AdminController
  def index
    @inquiries = Inquiry.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end
end
