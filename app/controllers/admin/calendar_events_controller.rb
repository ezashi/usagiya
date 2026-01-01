class Admin::CalendarEventsController < Admin::AdminController
  before_action :set_calendar_event, only: [ :show, :edit, :update, :destroy, :publish ]

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

    respond_to do |format|
      if @calendar_event.save
        format.html { redirect_to admin_calendar_events_path, notice: "カレンダーイベントを追加しました" }
        format.json { render json: { success: true, event: event_json(@calendar_event) } }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @calendar_event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @calendar_event.update(calendar_event_params)
        format.html { redirect_to admin_calendar_events_path, notice: "カレンダーイベントを更新しました" }
        format.json { render json: { success: true, event: event_json(@calendar_event) } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @calendar_event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @calendar_event.destroy
    redirect_to admin_calendar_events_path, notice: "カレンダーイベントを削除しました"
  end

  # お知らせを公開する
  def publish
    respond_to do |format|
      if @calendar_event.notice.present?
        if @calendar_event.notice.publish!
          format.json { render json: { success: true, message: "お知らせを公開しました" } }
        else
          format.json { render json: { success: false, error: "公開に失敗しました" }, status: :unprocessable_entity }
        end
      else
        format.json { render json: { success: false, error: "お知らせが見つかりません" }, status: :not_found }
      end
    end
  end

  private

  def set_calendar_event
    @calendar_event = CalendarEvent.find(params[:id])
  end

  def calendar_event_params
    params.require(:calendar_event).permit(:event_type, :event_date, :title, :color, :description, :show_in_notice)
  rescue ActionController::ParameterMissing
    # JSON形式でパラメータが送信された場合
    params.permit(:event_type, :event_date, :title, :color, :description, :show_in_notice)
  end

  def event_json(event)
    {
      id: event.id,
      event_type: event.event_type,
      event_date: event.event_date.strftime('%Y-%m-%d'),
      title: event.title,
      display_title: event.display_title,
      color: event.color,
      description: event.description,
      show_in_notice: event.show_in_notice?,
      notice_id: event.notice_id
    }
  end
end
