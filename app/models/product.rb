class Product < ApplicationRecord
  # バリデーション(エラーメッセージはja.ymlで管理)
  validates :name, presence: true
  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }
  validates :image_filename, presence: true

  # スコープ
  scope :visible, -> { where(visible: true) }
  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(display_order: :asc, created_at: :desc) }
  scope :by_category, ->(category) { where(category: category) }

  # カテゴリの定数
  CATEGORIES = {
    "recommended" => "おすすめ商品",
    "seasonal" => "季節限定商品",
    "regular" => "定番商品"
  }.freeze

  # 画像パスを返すメソッド
  def image_path
    "products/#{image_filename}"
  end

  # カテゴリ名を日本語で返す
  def category_name
    CATEGORIES[category] || category
  end
end
