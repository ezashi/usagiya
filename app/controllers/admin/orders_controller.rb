class Admin::OrdersController < Admin::AdminController
  before_action :set_order, only: [ :show, :update_status ]

  def index
    @orders = Order.includes(:order_items)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)

    # ステータスでフィルタリング
    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    # 日付範囲でフィルタリング
    if params[:start_date].present?
      @orders = @orders.where("created_at >= ?", params[:start_date])
    end

    if params[:end_date].present?
      @orders = @orders.where("created_at <= ?", params[:end_date].end_of_day)
    end

    # 検索
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @orders = @orders.where(
        "customer_name LIKE ? OR email LIKE ? OR phone LIKE ?",
        search_term, search_term, search_term
      )
    end
  end

  def show
    # set_orderで@orderが設定される
  end

  def update_status
    if @order.update(status: params[:status])
      redirect_to admin_order_path(@order), notice: "ステータスを更新しました。"
    else
      redirect_to admin_order_path(@order), alert: "ステータスの更新に失敗しました。"
    end
  end

  private

  def set_order
    @order = Order.includes(:order_items).find(params[:id])
  end
end
