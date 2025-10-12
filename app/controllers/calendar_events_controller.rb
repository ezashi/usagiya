class CalendarEventsController < ApplicationController
  def index
    @year = params[:year]&.to_i || Date.today.year
    @month = params[:month]&.to_i || Date.today.month

    # 前月・次月の計算
    current_date = Date.new(@year, @month, 1)
    prev_date = current_date.prev_month
    next_date = current_date.next_month

    @prev_year = prev_date.year
    @prev_month = prev_date.month
    @next_year = next_date.year
    @next_month = next_date.month

    # その月のイベントを取得
    @events = CalendarEvent.by_month(@year, @month).order(:event_date)

    # カレンダー生成
    @calendar = generate_calendar(@year, @month, @events)
  end

  private

  def generate_calendar(year, month, events)
    first_day = Date.new(year, month, 1)
    last_day = first_day.end_of_month

    calendar = []

    # 月初めの曜日までの空白
    first_day.wday.times do
      calendar << { date: nil, events: [] }
    end

    # 月の日付
    (first_day..last_day).each do |date|
      day_events = events.select { |e| e.event_date == date }
      calendar << { date: date, events: day_events }
    end

    calendar
  end
end