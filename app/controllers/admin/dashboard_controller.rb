class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    # 日本時間の今日の日付を取得
    jst = ActiveSupport::TimeZone["Tokyo"]
    today = Time.current.in_time_zone(jst).to_date

    # 今週の範囲（日本時間）
    week_start = today.beginning_of_week(:sunday)
    week_end = today.end_of_week(:sunday)

    # 今月の範囲
    month_start = today.beginning_of_month
    month_end = today.end_of_month

    # 統計データの取得（日本時間で計算）
    @today_orders = Order.where(
      created_at: jst.local(today.year, today.month, today.day, 0, 0, 0)..jst.local(today.year, today.month, today.day, 23, 59, 59)
    ).count

    @week_orders = Order.where(
      created_at: jst.local(week_start.year, week_start.month, week_start.day, 0, 0, 0)..jst.local(week_end.year, week_end.month, week_end.day, 23, 59, 59)
    ).count

    @monthly_orders = Order.where(
      created_at: jst.local(month_start.year, month_start.month, month_start.day, 0, 0, 0)..jst.local(month_end.year, month_end.month, month_end.day, 23, 59, 59)
    ).count

    @weekly_inquiries = Inquiry.where(
      created_at: jst.local(week_start.year, week_start.month, week_start.day, 0, 0, 0)..jst.local(week_end.year, week_end.month, week_end.day, 23, 59, 59)
    ).count

    @monthly_inquiries = Inquiry.where(
      created_at: jst.local(month_start.year, month_start.month, month_start.day, 0, 0, 0)..jst.local(month_end.year, month_end.month, month_end.day, 23, 59, 59)
    ).count

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

    # 日別の注文数とお問い合わせ数を取得（日本時間で集計）
    calendar_month_start = jst.local(@current_date.beginning_of_month.year, @current_date.beginning_of_month.month, @current_date.beginning_of_month.day, 0, 0, 0)
    calendar_month_end = jst.local(@current_date.end_of_month.year, @current_date.end_of_month.month, @current_date.end_of_month.day, 23, 59, 59)

    # 日本時間でグループ化
    daily_orders_raw = Order.where(created_at: calendar_month_start..calendar_month_end)
                            .select("DATE((created_at AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Tokyo') as order_date, COUNT(*) as count")
                            .group("order_date")
                            .to_a

    @daily_orders = daily_orders_raw.each_with_object({}) do |record, hash|
      hash[Date.parse(record.order_date.to_s)] = record.count
    end

    daily_inquiries_raw = Inquiry.where(created_at: calendar_month_start..calendar_month_end)
                                 .select("DATE((created_at AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Tokyo') as inquiry_date, COUNT(*) as count")
                                 .group("inquiry_date")
                                 .to_a

    @daily_inquiries = daily_inquiries_raw.each_with_object({}) do |record, hash|
      hash[Date.parse(record.inquiry_date.to_s)] = record.count
    end
  end
end
