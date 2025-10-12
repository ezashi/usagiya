module CalendarEventsHelper
  def event_type_badge_class(event_type)
    case event_type
    when "regular_holiday"
      "bg-red-500 text-white"
    when "irregular_holiday"
      "bg-yellow-500 text-black"
    when "sales_start"
      "bg-green-500 text-white"
    when "sales_end"
      "bg-orange-500 text-white"
    when "other"
      "bg-blue-500 text-white"
    else
      "bg-gray-500 text-white"
    end
  end

  def event_type_color(event_type)
    case event_type
    when "regular_holiday"
      "#dc3545"
    when "irregular_holiday"
      "#ffc107"
    when "sales_start"
      "#28a745"
    when "sales_end"
      "#fd7e14"
    when "other"
      "#007bff"
    else
      "#6c757d"
    end
  end
end
