class OrderItem < ApplicationRecord
  belongs_to :order

  # バリデーション
  validates :product_name, presence: true
  validates :product_type, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :subtotal, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
