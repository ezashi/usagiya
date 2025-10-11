class Order < ApplicationRecord
  # エイリアスを設定して、ビューで使用している名前を既存のカラム名にマッピング
  alias_attribute :customer_postal_code, :postal_code
  alias_attribute :customer_address, :address
  alias_attribute :customer_phone, :phone
  alias_attribute :customer_email, :email
  alias_attribute :shipping_name, :delivery_name
  alias_attribute :shipping_postal_code, :delivery_postal_code
  alias_attribute :shipping_address, :delivery_address
  alias_attribute :shipping_phone, :delivery_phone
  alias_attribute :shipping_type, :same_address
  alias_attribute :wrapping, :wrapping_type

  # ご注文者様情報のバリデーション
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :postal_code, presence: true, format: { with: /\A\d{3}-?\d{4}\z/, allow_blank: true }
  validates :address, presence: true, length: { maximum: 200 }
  validates :phone, presence: true, format: { with: /\A\d{2,4}-?\d{2,4}-?\d{3,4}\z/, allow_blank: true }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  # 支払い方法のバリデーション
  validates :payment_method, presence: true, inclusion: { in: %w[credit_card cash_on_delivery fukui_bank_transfer yucho_bank_transfer], allow_blank: true }

  # 包装のバリデーション
  validates :wrapping_type, presence: true, inclusion: { in: %w[no_wrapping logo_red logo_blue rabbit_pink], allow_blank: true }

  # 送り先のバリデーション（別の住所の場合のみ）
  validates :delivery_name, presence: true, length: { maximum: 50 }, if: :different_shipping_address?
  validates :delivery_postal_code, presence: true, format: { with: /\A\d{3}-?\d{4}\z/, allow_blank: true }, if: :different_shipping_address?
  validates :delivery_address, presence: true, length: { maximum: 200 }, if: :different_shipping_address?
  validates :delivery_phone, presence: true, format: { with: /\A\d{2,4}-?\d{2,4}-?\d{3,4}\z/, allow_blank: true }, if: :different_shipping_address?

  # カスタムバリデーション: 少なくとも1つの商品が注文されているか
  validate :at_least_one_product_ordered

  private

  # 別の住所に送るかどうかを判定
  def different_shipping_address?
    same_address == "different"
  end

  # 少なくとも1つの商品が注文されているかチェック
  def at_least_one_product_ordered
    if products.blank? || products.values.all? { |qty| qty.to_i.zero? }
      errors.add(:base, :no_products)
    end
  end
end
