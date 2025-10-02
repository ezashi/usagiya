class PagesController < ApplicationController
  def home
    @featured_products = Product.featured.recent.limit(6)
    @notices = Notice.published.limit(5)
    @calendar_events = CalendarEvent.where(
      event_date: Date.today.beginning_of_month..Date.today.end_of_month
    ).order(:event_date)
  end
end
