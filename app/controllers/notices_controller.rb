class NoticesController < ApplicationController
  def index
    @notices = Notice.published
  end

  def show
    @notice = Notice.find(params[:id])
  end
end
