class Admin::CalendarEventsController < Admin::AdminController
  before_action :set_calendar_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @year = params[:year]&.to_i || Date.today.year
    @month = params[:month]&.to_i || Date.today.month
    @calendar_events = CalendarEvent.by_month(@year, @month).order(:event_date)
  end

  def new
    @calendar_event = CalendarEvent.new
  end

  def create
    @calendar_event = CalendarEvent.new(calendar_event_params)

    if @calendar_event.save
      redirect_to admin_calendar_events_path, notice: "カレンダーイベントを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @calendar_event.update(calendar_event_params)
      redirect_to admin_calendar_events_path, notice: "カレンダーイベントを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @calendar_event.destroy
    redirect_to admin_calendar_events_path, notice: "カレンダーイベントを削除しました"
  end

  private

  def set_calendar_event
    @calendar_event = CalendarEvent.find(params[:id])
  end

  def calendar_event_params
    params.require(:calendar_event).permit(:event_type, :event_date, :description, :auto_notice)
  end
end
