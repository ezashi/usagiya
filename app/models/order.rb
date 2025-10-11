class Order < ApplicationRecord
  # ご注文者様情報のバリデーション
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :customer_postal_code, presence: true, format: { with: /\A\d{3}-?\d{4}\z/ }
  validates :customer_address, presence: true, length: { maximum: 200 }
  validates :customer_phone, presence: true, format: { with: /\A\d{2,4}-?\d{2,4}-?\d{3,4}\z/ }
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # 支払い方法のバリデーション
  validates :payment_method, presence: true, inclusion: { in: %w[credit_card cash_on_delivery fukui_bank_transfer yucho_bank_transfer] }

  # 包装のバリデーション
  validates :wrapping, presence: true, inclusion: { in: %w[no_wrapping logo_red logo_blue rabbit_pink] }

  # 送り先のバリデーション（別の住所の場合のみ）
  validates :shipping_name, presence: true, length: { maximum: 50 }, if: :different_shipping_address?
  validates :shipping_postal_code, presence: true, format: { with: /\A\d{3}-?\d{4}\z/ }, if: :different_shipping_address?
  validates :shipping_address, presence: true, length: { maximum: 200 }, if: :different_shipping_address?
  validates :shipping_phone, presence: true, format: { with: /\A\d{2,4}-?\d{2,4}-?\d{3,4}\z/ }, if: :different_shipping_address?

  # カスタムバリデーション: 少なくとも1つの商品が注文されているか
  validate :at_least_one_product_ordered

  private

  # 別の住所に送るかどうかを判定
  def different_shipping_address?
    shipping_type == "different"
  end

  # 少なくとも1つの商品が注文されているかチェック
  def at_least_one_product_ordered
    # productsフィールドに商品データが保存されていると仮定
    if products.blank? || products.values.all? { |qty| qty.to_i.zero? }
      errors.add(:base, :no_products)
    end
  end
end
