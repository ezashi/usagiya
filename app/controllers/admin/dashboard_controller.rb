class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    # 今日の日付
    today = Date.today

    # 今週の範囲
    week_start = today.beginning_of_week(:sunday)
    week_end = today.end_of_week(:sunday)

    # 今月の範囲
    month_start = today.beginning_of_month
    month_end = today.end_of_month

    # 統計データの取得
    @today_orders = Order.where(created_at: today.beginning_of_day..today.end_of_day).count
    @week_orders = Order.where(created_at: week_start.beginning_of_day..week_end.end_of_day).count
    @monthly_orders = Order.where(created_at: month_start..month_end).count

    @weekly_inquiries = Inquiry.where(created_at: week_start.beginning_of_day..week_end.end_of_day).count
    @monthly_inquiries = Inquiry.where(created_at: month_start..month_end).count

    # カレンダーの設定
    if params[:month].present?
      @current_date = Date.parse(params[:month])
    else
      @current_date = today
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
    calendar_month_start = @current_date.beginning_of_month
    calendar_month_end = @current_date.end_of_month

    @daily_orders = Order.where(created_at: calendar_month_start..calendar_month_end)
                         .group("DATE(created_at)")
                         .count
                         .transform_keys { |key| Date.parse(key) }

    @daily_inquiries = Inquiry.where(created_at: calendar_month_start..calendar_month_end)
                              .group("DATE(created_at)")
                              .count
                              .transform_keys { |key| Date.parse(key) }
  end
end
