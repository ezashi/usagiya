class OrderItem < ApplicationRecord
  belongs_to :order

  validates :product_type, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 商品名を取得
  def product_name
    Order::PRODUCT_PRICES.dig(product_type, :name) || product_type
  end

  # 単価を取得
  def unit_price
    Order::PRODUCT_PRICES.dig(product_type, :price) || 0
  end

  # 小計を計算
  def subtotal
    unit_price * quantity.to_i
  end

  # price_per_unit エイリアス（既存コードとの互換性のため）
  alias_method :price_per_unit, :unit_price
end
