class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  # Enums
  enum :payment_method, {
    credit_card: 0,
    cash_on_delivery: 1,
    fukui_bank_transfer: 2,
    yucho_bank_transfer: 3
  }, prefix: true

  # Validations
  validates :customer_name, presence: { message: "ご注文者様のお名前を入力してください" }
  validates :postal_code, presence: { message: "ご注文者様の郵便番号を入力してください" },
                          format: { with: /\A\d{3}-?\d{4}\z/, message: "郵便番号は7桁の数字で入力してください（例：123-4567）" }
  validates :address, presence: { message: "ご注文者様のご住所を入力してください" }
  validates :phone, presence: { message: "ご注文者様の電話番号を入力してください" },
                    format: { with: /\A\d{10,11}\z/, message: "電話番号は10桁または11桁の数字で入力してください" }
  validates :email, presence: { message: "E-MAILを入力してください" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "正しいメールアドレスを入力してください" }
  validates :payment_method, presence: { message: "支払い方法を選択してください" }

  # Conditional validations for delivery address
  with_options unless: :same_address? do
    validates :delivery_name, presence: { message: "お送り先のお名前を入力してください" }
    validates :delivery_postal_code, presence: { message: "お送り先の郵便番号を入力してください" },
                                     format: { with: /\A\d{3}-?\d{4}\z/, message: "郵便番号は7桁の数字で入力してください（例：123-4567）" }
    validates :delivery_address, presence: { message: "お送り先の住所を入力してください" }
    validates :delivery_phone, presence: { message: "お送り先の電話番号を入力してください" },
                               format: { with: /\A\d{10,11}\z/, message: "電話番号は10桁または11桁の数字で入力してください" }
  end

  validate :at_least_one_item

  # Callbacks
  before_create :calculate_total
  after_create :send_order_confirmation

  # Payment method labels
  def self.payment_method_options
    {
      "クレジットカード払い（VISA / Master / JCB / American Express / ダイナースクラブ）" => "credit_card",
      "代引き（手数料がかかります）" => "cash_on_delivery",
      "福井信用金庫 事前振込（手数料はご負担ください）" => "fukui_bank_transfer",
      "ゆうちょ銀行 事前振込（手数料はご負担ください）" => "yucho_bank_transfer"
    }
  end

  # Delivery time options
  def self.delivery_time_options
    [
      "午前中",
      "14~16時",
      "16~18時",
      "18~20時",
      "19~20時",
      "時間指定なし"
    ]
  end

  # Wrapping options
  def self.wrapping_options
    [
      "もちパイ・帯のみ（包装なし）",
      "「うさぎや」ロゴデザイン・赤",
      "「うさぎや」ロゴデザイン・青",
      "うさぎ柄・ピンク"
    ]
  end

  private

  def at_least_one_item
    valid_items = order_items.reject(&:marked_for_destruction?).select { |item| item.quantity.to_i > 0 }
    if valid_items.empty?
      errors.add(:base, "商品を1つ以上選択してください")
    end
  end

  def calculate_total
    self.total_amount = order_items.reject(&:marked_for_destruction?).sum do |item|
      item.quantity.to_i * (item.unit_price || item.price_per_unit).to_i
    end
  end

  def send_order_confirmation
    OrderMailer.customer_confirmation(self).deliver_later
    OrderMailer.admin_notification(self).deliver_later
  end
end
