class Product < ApplicationRecord
  # Active Storage associations
  has_one_attached :image
  # has_rich_text :description  # カスタムエディタに変更したためコメントアウト

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true

  # Scopes
  scope :published, -> { where(visible: true) }
  scope :featured, -> { where(featured: true).order(:featured_order, :display_order) }
  scope :seasonal, -> { where(seasonal: true).order(:seasonal_order, :display_order) }
  scope :ordered_by_display, -> { order(:display_order) }
  scope :draft_featured, -> { where(draft_featured: true).order(:draft_featured_order) }
  scope :draft_seasonal, -> { where(draft_seasonal: true).order(:draft_seasonal_order) }

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
    update(visible: true, published_at: Time.current, draft_saved_at: nil)
  end

  def unpublish!
    update(visible: false)
  end

  # 下書き保存されているかを判定（非公開の場合）
  def draft?
    !visible
  end

  # 公開中かを判定
  def published?
    visible
  end

  # 編集中（下書き保存あり）かを判定
  def editing?
    draft_saved_at.present? || has_draft?
  end

  # 下書き内容があるかを判定
  def has_draft?
    draft_name.present? ||
    draft_price.present? ||
    draft_description.present? ||
    draft_featured_order.present? ||
    draft_seasonal_order.present?
  end

  # 下書き内容を保存（商品詳細の編集用）
  def save_as_draft(params)
    Rails.logger.debug "=== save_as_draft DEBUG ==="
    Rails.logger.debug "params: #{params.inspect}"
    Rails.logger.debug "params[:name]: #{params[:name].inspect}"
    Rails.logger.debug "params[:price]: #{params[:price].inspect}"

    update_columns(
      draft_name: params[:name],
      draft_price: params[:price].to_i,
      draft_description: params[:description],
      draft_featured: params[:featured].to_s == "1" || params[:featured] == true,
      draft_seasonal: params[:seasonal].to_s == "1" || params[:seasonal] == true,
      draft_saved_at: Time.current
    )

    Rails.logger.debug "保存後 - draft_name: #{draft_name}, draft_price: #{draft_price}"
  end

  # 下書き内容を公開（本体にコピー）
  def publish_draft
    Rails.logger.debug "=== publish_draft DEBUG ==="
    Rails.logger.debug "has_draft?: #{has_draft?}"
    Rails.logger.debug "draft_name: #{draft_name.inspect}"
    Rails.logger.debug "draft_price: #{draft_price.inspect}"

    if has_draft?
      Rails.logger.debug "下書き内容を本体にコピー"
      result = update(
        name: draft_name || name,
        price: draft_price || price,
        description: draft_description || description,
        featured: draft_featured,
        seasonal: draft_seasonal,
        visible: true,
        published_at: Time.current,
        draft_saved_at: nil
      )
      Rails.logger.debug "更新結果: #{result}"
      Rails.logger.debug "更新後 - name: #{name}, price: #{price}"
      clear_draft_content
    else
      Rails.logger.debug "下書き内容なし - 通常の公開"
      update(visible: true, published_at: Time.current, draft_saved_at: nil)
    end
  end

  # 下書き内容をクリア
  def clear_draft_content
    update_columns(
      draft_name: nil,
      draft_price: nil,
      draft_description: nil,
      draft_featured: false,
      draft_seasonal: false,
      draft_featured_order: nil,
      draft_seasonal_order: nil,
      draft_saved_at: nil
    )
  end

  # おすすめ商品に追加
  def add_to_featured
    return if featured

    update(
      featured: true,
      featured_order: self.class.next_featured_order
    )
  end

  # おすすめ商品から削除
  def remove_from_featured
    return unless featured

    update(featured: false, featured_order: nil)
    reorder_featured_products
  end

  # 季節限定商品に追加
  def add_to_seasonal
    return if seasonal

    update(
      seasonal: true,
      seasonal_order: self.class.next_seasonal_order
    )
  end

  # 季節限定商品から削除
  def remove_from_seasonal
    return unless seasonal

    update(seasonal: false, seasonal_order: nil)
    reorder_seasonal_products
  end

  # おすすめ商品の下書き保存（並び替え用）
  def save_featured_draft(order_position)
    update_columns(
      draft_featured: true,
      draft_featured_order: order_position,
      draft_saved_at: Time.current
    )
  end

  # 季節限定商品の下書き保存（並び替え用）
  def save_seasonal_draft(order_position)
    update_columns(
      draft_seasonal: true,
      draft_seasonal_order: order_position,
      draft_saved_at: Time.current
    )
  end

  # おすすめ商品の下書きを公開
  def publish_featured_draft
    if draft_featured && draft_featured_order.present?
      update(
        featured: true,
        featured_order: draft_featured_order,
        draft_featured: false,
        draft_featured_order: nil,
        draft_saved_at: nil
      )
    end
  end

  # 季節限定商品の下書きを公開
  def publish_seasonal_draft
    if draft_seasonal && draft_seasonal_order.present?
      update(
        seasonal: true,
        seasonal_order: draft_seasonal_order,
        draft_seasonal: false,
        draft_seasonal_order: nil,
        draft_saved_at: nil
      )
    end
  end

  # おすすめ商品の下書きをクリア
  def clear_featured_draft
    update_columns(
      draft_featured: false,
      draft_featured_order: nil
    )
  end

  # 季節限定商品の下書きをクリア
  def clear_seasonal_draft
    update_columns(
      draft_seasonal: false,
      draft_seasonal_order: nil
    )
  end

  # 画像URLを取得
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

  # おすすめ商品の並び順を再整理
  def reorder_featured_products
    Product.featured.each_with_index do |product, index|
      product.update_column(:featured_order, index + 1)
    end
  end

  # 季節限定商品の並び順を再整理
  def reorder_seasonal_products
    Product.seasonal.each_with_index do |product, index|
      product.update_column(:seasonal_order, index + 1)
    end
  end
end
