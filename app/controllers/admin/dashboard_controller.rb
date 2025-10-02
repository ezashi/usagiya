class Admin::DashboardController < Admin::BaseController
  def index
    @recent_orders = Order.order(created_at: :desc).limit(10)
    @recent_inquiries = Inquiry.order(created_at: :desc).limit(10)
    @total_orders = Order.count
    @total_inquiries = Inquiry.count
  end
end
