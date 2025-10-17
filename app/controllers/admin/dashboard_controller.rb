class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    # 統計データの取得
    @total_products = Product.count
    @monthly_orders = Order.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @monthly_inquiries = Inquiry.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @monthly_revenue = Order.where(
      created_at: Time.current.beginning_of_month..Time.current.end_of_month,
      status: [ "completed", "shipped" ]
    ).sum(:total_amount)

    # カレンダーの設定
    if params[:month].present?
      @current_date = Date.parse(params[:month])
    else
      @current_date = Date.today
    end

    @prev_month = (@current_date - 1.month).strftime("%Y-%m-01")
    @next_month = (@current_date + 1.month).strftime("%Y-%m-01")

    # カレンダーの週配列を作成
    start_date = @current_date.beginning_of_month.beginning_of_week(:sunday)
    end_date = @current_date.end_of_month.end_of_week(:sunday)

    @calendar_weeks = []
    current_date = start_date

    while current_date <= end_date
      week = []
      7.times do
        if current_date.month == @current_date.month
          week << current_date
        else
          week << nil
        end
        current_date += 1.day
      end
      @calendar_weeks << week
    end

    # 日別の注文数とお問い合わせ数を取得
    month_start = @current_date.beginning_of_month
    month_end = @current_date.end_of_month

    @daily_orders = Order.where(created_at: month_start..month_end)
                         .group("DATE(created_at)")
                         .count
                         .transform_keys { |key| Date.parse(key) }

    @daily_inquiries = Inquiry.where(created_at: month_start..month_end)
                              .group("DATE(created_at)")
                              .count
                              .transform_keys { |key| Date.parse(key) }
  end
end
