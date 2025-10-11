class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true,
    reject_if: proc { |attributes| attributes["quantity"].to_i <= 0 }

  # バリデーション
  validates :customer_name, presence: true
  validates :postal_code, presence: true, format: { with: /\A\d{3}-?\d{4}\z/, message: "は7桁の数字で入力してください(ハイフンあり・なし両対応)" }
  validates :address, presence: true
  validates :phone, presence: true, format: { with: /\A\d{10,11}\z/, message: "は10桁または11桁の数字で入力してください" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "の形式が正しくありません" }
  validates :payment_method, presence: true
  validates :wrapping_type, presence: true

  # 別住所の場合のバリデーション
  with_options if: :different_address? do
    validates :delivery_name, presence: true
    validates :delivery_postal_code, presence: true, format: { with: /\A\d{3}-?\d{4}\z/ }
    validates :delivery_address, presence: true
    validates :delivery_phone, presence: true, format: { with: /\A\d{10,11}\z/ }
  end

  # 少なくとも1つの商品が注文されていることを確認
  validate :must_have_at_least_one_item

  # コールバック
  before_validation :calculate_total
  after_create :send_confirmation_emails

  # 定数: もちパイの価格設定
  PRODUCT_PRICES = {
    "mochipai_6" => { name: "もちパイ6個入り", price: 1200 },
    "mochipai_8" => { name: "もちパイ8個入り", price: 1600 },
    "mochipai_10" => { name: "もちパイ10個入り", price: 2000 },
    "mochipai_12" => { name: "もちパイ12個入り", price: 2400 },
    "mochipai_15" => { name: "もちパイ15個入り", price: 3000 },
    "mochipai_20" => { name: "もちパイ20個入り", price: 4000 }
  }.freeze

  # 支払い方法の選択肢
  PAYMENT_METHODS = {
    "credit_card" => "クレジットカード払い(VISA / Master / JCB / American Express / ダイナースクランブル)",
    "cash_on_delivery" => "代引き(手数料がかかります)",
    "bank_transfer_fukui" => "福井信用金庫 事前振込(手数料はご負担ください)",
    "bank_transfer_yucho" => "ゆうちょ銀行 事前振込(手数料はご負担ください)"
  }.freeze

  # 配送時間の選択肢
  DELIVERY_TIMES = [
    "午前中",
    "14~16時",
    "16~18時",
    "18~20時",
    "19~20時",
    "時間指定なし"
  ].freeze

  # 包装の選択肢
  WRAPPING_OPTIONS = {
    "none" => "もちパイ・帯のみ(包装なし)",
    "logo_red" => "「うさぎや」ロゴデザイン・赤",
    "logo_blue" => "「うさぎや」ロゴデザイン・青",
    "rabbit_pink" => "うさぎ柄・ピンク"
  }.freeze

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :pending, -> { where(status: "pending") }

  # インスタンスメソッド
  def different_address?
    !same_address
  end

  def same_address?
    same_address == true || same_address == "1" || same_address == 1
  end

  def payment_method_label
    PAYMENT_METHODS[payment_method]
  end

  def wrapping_type_label
    WRAPPING_OPTIONS[wrapping_type]
  end

  private

  def must_have_at_least_one_item
    if order_items.reject(&:marked_for_destruction?).sum(:quantity) <= 0
      errors.add(:base, "商品を1つ以上選択してください")
    end
  end

  def calculate_total
    self.total_amount = order_items.reject(&:marked_for_destruction?).sum do |item|
      next 0 if item.quantity.to_i <= 0
      PRODUCT_PRICES[item.product_type][:price] * item.quantity.to_i
    end
  end

  def send_confirmation_emails
    # 顧客への確認メール
    OrderMailer.customer_confirmation(self).deliver_later

    # 管理者への通知メール
    OrderMailer.admin_notification(self).deliver_later
  rescue => e
    Rails.logger.error "メール送信エラー: #{e.message}"
    # エラーが発生してもメール送信失敗で注文自体を失敗させない
  end
end
