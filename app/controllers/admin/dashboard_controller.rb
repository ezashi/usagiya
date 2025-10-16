class Admin::DashboardController < Admin::AdminController
  def index
    # 全商品を取得（表示順でソート）
    @products = Product.ordered_by_display.page(params[:page]).per(50)

    # 統計情報
    @total_products = Product.count
    @featured_products_count = Product.where(featured: true).count
    @seasonal_products_count = Product.where(seasonal: true).count
    @visible_products_count = Product.where(visible: true).count

    # 最近の注文
    @recent_orders = Order.order(created_at: :desc).limit(5)

    # 最近のお問い合わせ
    @recent_inquiries = Inquiry.order(created_at: :desc).limit(5)
  end
end
