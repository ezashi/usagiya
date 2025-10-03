class Notice < ApplicationRecord
  # Active Storage and Action Text
  has_rich_text :content

  # Validations
  validates :content, presence: true

  # Scopes
  # published_atが設定されていれば公開済みとみなす
  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def publish!
    update(published_at: Time.current)
  end

  def unpublish!
    update(published_at: nil)
  end

  def published?
    published_at.present?
  end

  def draft?
    !published?
  end
end
