class Admin::DashboardController < Admin::AdminController
  def index
    # 当月の注文とお問い合わせデータを取得
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.today.beginning_of_month

    # 月の開始日と終了日
    month_start = @current_month.beginning_of_month
    month_end = @current_month.end_of_month

    # 当月の注文データを日付ごとにグループ化
    @orders_by_date = Order.where(created_at: month_start..month_end)
                           .group_by { |order| order.created_at.to_date }

    # 当月のお問い合わせ数を日付ごとにグループ化
    @inquiries_by_date = Inquiry.where(created_at: month_start..month_end)
                                .group_by { |inquiry| inquiry.created_at.to_date }

    # 統計情報（今週、本日、今月）
    today = Date.today
    week_start = today.beginning_of_week(:sunday)  # 日曜日を週の始まりとする
    week_end = today.end_of_week(:sunday)
    current_month_start = today.beginning_of_month
    current_month_end = today.end_of_month

    @today_orders_count = Order.where(created_at: today.beginning_of_day..today.end_of_day).count
    @this_week_orders_count = Order.where(created_at: week_start.beginning_of_day..week_end.end_of_day).count
    @this_month_inquiries_count = Inquiry.where(created_at: current_month_start.beginning_of_day..current_month_end.end_of_day).count
    @this_week_inquiries_count = Inquiry.where(created_at: week_start.beginning_of_day..week_end.end_of_day).count

    # カレンダー表示用のデータ構造を作成
    @calendar_data = build_calendar_data(month_start, month_end)
  end

  private

  def build_calendar_data(month_start, month_end)
    calendar_data = {}

    (month_start..month_end).each do |date|
      # その日の注文
      day_orders = @orders_by_date[date] || []

      # その日のお問い合わせ
      day_inquiries = @inquiries_by_date[date] || []

      # その日の注文商品を集計
      order_products = []
      day_orders.each do |order|
        next unless order.products.is_a?(Hash)

        order.products.each do |product_key, quantity|
          next if quantity.to_i.zero?

          # 商品名を日本語に変換
          product_name = case product_key
          when "6pieces" then "もちパイ6個入り"
          when "8pieces" then "もちパイ8個入り"
          when "10pieces" then "もちパイ10個入り"
          when "12pieces" then "もちパイ12個入り"
          when "15pieces" then "もちパイ15個入り"
          when "20pieces" then "もちパイ20個入り"
          else product_key
          end

          order_products << { name: product_name, quantity: quantity.to_i }
        end
      end

      calendar_data[date.day] = {
        date: date,
        orders_count: day_orders.size,
        inquiries_count: day_inquiries.size,
        order_products: order_products,
        orders: day_orders,  # 注文のIDを取得するために追加
        inquiries: day_inquiries  # お問い合わせのIDを取得するために追加
      }
    end

    calendar_data
  end
end
