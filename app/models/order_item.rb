class OrderItem < ApplicationRecord
  belongs_to :order

  # Product types and prices for frozen mochi pies
  PRODUCT_TYPES = {
    "mochi_pie_6" => { name: "もちパイ6個入り", price: 1800 },
    "mochi_pie_8" => { name: "もちパイ8個入り", price: 2400 },
    "mochi_pie_10" => { name: "もちパイ10個入り", price: 3000 },
    "mochi_pie_12" => { name: "もちパイ12個入り", price: 3600 },
    "mochi_pie_15" => { name: "もちパイ15個入り", price: 4500 },
    "mochi_pie_20" => { name: "もちパイ20個入り", price: 6000 }
  }

  # Validations
  validates :product_type, presence: { message: "商品タイプを選択してください" },
                           inclusion: { in: PRODUCT_TYPES.keys, message: "有効な商品タイプを選択してください" }
  validates :quantity, presence: { message: "数量を入力してください" },
                       numericality: { only_integer: true, greater_than: 0, message: "数量は1以上の整数で入力してください" }

  # Callbacks
  before_validation :set_unit_price

  def product_name
    PRODUCT_TYPES.dig(product_type, :name)
  end

  def price_per_unit
    PRODUCT_TYPES.dig(product_type, :price)
  end

  def subtotal
    quantity.to_i * unit_price.to_i
  end

  def self.product_type_options
    PRODUCT_TYPES.map { |key, value| [ value[:name], key ] }
  end

  private

  def set_unit_price
    # This is stored for historical record in case prices change
    self.unit_price = PRODUCT_TYPES.dig(product_type, :price) if product_type.present?
  end
end
