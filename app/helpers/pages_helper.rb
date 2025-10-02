module PagesHelper
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

  def calendar_day_class(day_info)
    return "bg-gray-100" unless day_info[:date]

    classes = [ "border border-gray-200" ]

    # 日曜日
    if day_info[:date].sunday?
      classes << "bg-red-50 text-red-700"
    # 土曜日
    elsif day_info[:date].saturday?
      classes << "bg-blue-50 text-blue-700"
    else
      classes << "bg-white"
    end

    # 今日
    if day_info[:date] == Date.today
      classes << "ring-2 ring-red-500"
    end

    # 定休日・不定休
    if day_info[:events].any? { |e| e.regular_holiday? || e.irregular_holiday? }
      classes << "bg-gray-200"
    end

    classes.join(" ")
  end

  def event_badge_class(event_type)
    case event_type
    when "regular_holiday", "irregular_holiday"
      "text-red-600"
    when "sales_start"
      "text-green-600"
    when "sales_end"
      "text-orange-600"
    else
      "text-blue-600"
    end
  end

  def event_type_label(event_type)
    case event_type
    when "regular_holiday"
      "定休"
    when "irregular_holiday"
      "休"
    when "sales_start"
      "販売開始"
    when "sales_end"
      "販売終了"
    else
      "他"
    end
  end
end
