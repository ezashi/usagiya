class Admin::NoticesController < Admin::AdminController
  before_action :set_notice, only: [ :edit, :update, :destroy, :publish ]

  def index
    @notices = Notice.all.recent
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new

    if params[:commit] == "公開"
      # 公開する場合
      @notice.title = params[:notice][:title]
      @notice.content = params[:notice][:content]
      @notice.published_at = Time.current

      if @notice.save
        redirect_to admin_notices_path, notice: "お知らせを公開しました"
      else
        render :new, status: :unprocessable_entity
      end
    else
      # 下書き保存の場合
      @notice.draft_title = params[:notice][:title]
      @notice.draft_content = params[:notice][:content]
      @notice.draft_saved_at = Time.current

      if @notice.save(validate: false)
        redirect_to edit_admin_notice_path(@notice), notice: "お知らせを下書き保存しました"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    # 下書きがある場合は、フォームに下書きの内容を表示
    if @notice.has_draft?
      @notice.title = @notice.draft_title
      @notice.content = @notice.draft_content
    end
  end

  def update
    if params[:commit] == "公開"
      # 公開ボタンが押された場合
      # フォームから送信された内容を公開
      @notice.title = params[:notice][:title]
      @notice.content = params[:notice][:content]
      @notice.published_at = Time.current

      # 下書きをクリア
      @notice.draft_title = nil
      @notice.draft_content = nil
      @notice.draft_saved_at = nil

      if @notice.save
        redirect_to admin_notices_path, notice: "お知らせを公開しました"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # 下書き保存の場合
      @notice.draft_title = params[:notice][:title]
      @notice.draft_content = params[:notice][:content]
      @notice.draft_saved_at = Time.current
      # published_atはそのまま（公開中なら公開のまま、未公開なら未公開のまま）

      if @notice.save(validate: false)
        redirect_to edit_admin_notice_path(@notice), notice: "お知らせを下書き保存しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @notice.destroy
    redirect_to admin_notices_path, notice: "お知らせを削除しました"
  end

  # 公開/非公開の切り替え
  def publish
    if @notice.published?
      @notice.unpublish!
      redirect_to admin_notices_path, notice: "お知らせを非公開にしました"
    else
      @notice.publish!
      redirect_to admin_notices_path, notice: "お知らせを公開しました"
    end
  end

  private

  def set_notice
    @notice = Notice.find(params[:id])
  end

  def notice_params
    params.require(:notice).permit(:title, :content)
  end
end
