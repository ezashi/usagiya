class Admin::NoticesController < Admin::AdminController
  before_action :set_notice, only: [ :edit, :update, :destroy, :publish ]

  def index
    @notices = Notice.all.recent
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)

    # params[:commit]で押されたボタンを判定
    if params[:commit] == "公開"
      @notice.published_at = Time.current
    end

    if @notice.save
      if params[:commit] == "公開"
        redirect_to admin_notices_path, notice: "お知らせを公開しました"
      else
        redirect_to edit_admin_notice_path(@notice), notice: "お知らせを下書き保存しました"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # params[:commit]で押されたボタンを判定
    if params[:commit] == "公開"
      @notice.published_at = Time.current
    else
      # 下書き保存の場合はpublished_atをnilにする
      @notice.published_at = nil
    end

    if @notice.update(notice_params)
      if params[:commit] == "公開"
        redirect_to admin_notices_path, notice: "お知らせを公開しました"
      else
        redirect_to edit_admin_notice_path(@notice), notice: "お知らせを下書き保存しました（一般ユーザーには非公開）"
      end
    else
      render :edit, status: :unprocessable_entity
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
