module Admin::CalendarEventsHelper
  def event_type_badge_class(event_type)
    case event_type
    when "regular_holiday"
      "bg-gray-100 text-gray-800"
    when "sales_start"
      "bg-green-100 text-green-800"
    when "sales_end"
      "bg-red-100 text-red-800"
    when "irregular_holiday"
      "bg-yellow-100 text-yellow-800"
    when "other"
      "bg-blue-100 text-blue-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
