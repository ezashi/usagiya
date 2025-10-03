class Product < ApplicationRecord
  # Active Storage associations
  has_one_attached :image
  has_rich_text :description

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :published, -> { where(visible: true) }
  scope :featured, -> { where(featured: true).order(:featured_order, :display_order) }
  scope :seasonal, -> { where(seasonal: true).order(:seasonal_order, :display_order) }
  scope :ordered_by_display, -> { order(:display_order) }

  # Class methods
  def self.next_featured_order
    featured.maximum(:featured_order).to_i + 1
  end

  def self.next_seasonal_order
    seasonal.maximum(:seasonal_order).to_i + 1
  end

  def self.next_display_order
    maximum(:display_order).to_i + 1
  end

  # Instance methods
  def publish!
    update(visible: true, published_at: Time.current)
  end

  def unpublish!
    update(visible: false)
  end

  def add_to_featured
    return if featured

    update(
      featured: true,
      featured_order: self.class.next_featured_order
    )
  end

  def remove_from_featured
    return unless featured

    update(featured: false, featured_order: nil)
    reorder_featured_products
  end

  def add_to_seasonal
    return if seasonal

    update(
      seasonal: true,
      seasonal_order: self.class.next_seasonal_order
    )
  end

  def remove_from_seasonal
    return unless seasonal

    update(seasonal: false, seasonal_order: nil)
    reorder_seasonal_products
  end

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    elsif image_filename.present?
      # 既存の画像ファイル名がある場合
      "/assets/products/#{image_filename}"
    else
      nil
    end
  end

  private

  def reorder_featured_products
    Product.featured.each_with_index do |product, index|
      product.update_column(:featured_order, index + 1)
    end
  end

  def reorder_seasonal_products
    Product.seasonal.each_with_index do |product, index|
      product.update_column(:seasonal_order, index + 1)
    end
  end
end
