class Admin::NoticesController < Admin::BaseController
  before_action :set_notice, only: [ :show, :edit, :update, :destroy ]

  def index
    @notices = Notice.all.recent
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)

    if @notice.save
      redirect_to admin_notices_path, notice: "お知らせを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @notice.update(notice_params)
      redirect_to admin_notices_path, notice: "お知らせを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @notice.destroy
    redirect_to admin_notices_path, notice: "お知らせを削除しました"
  end

  private

  def set_notice
    @notice = Notice.find(params[:id])
  end

  def notice_params
    params.require(:notice).permit(:title, :content, :published_at)
  end
end
