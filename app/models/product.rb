class Product < ApplicationRecord
  has_one_attached :image
  has_many :order_items, dependent: :destroy

  # Validations
  validates :name, presence: { message: "商品名を入力してください" }
  validates :price, presence: { message: "値段を入力してください" },
                    numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "値段は0以上の整数で入力してください" }
  validates :description, presence: { message: "説明文を入力してください" }
  validates :image, presence: { message: "画像を添付してください" }

  # Scopes
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(created_at: :desc) }

  # Custom validation for image
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.blob.byte_size <= 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end

    acceptable_types = [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]
    unless acceptable_types.include?(image.blob.content_type)
      errors.add(:image, "はJPEG、PNG、GIF形式でアップロードしてください")
    end
  end
end
