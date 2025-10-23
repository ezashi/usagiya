class Notice < ApplicationRecord
  # Active Storage and Action Text
  has_rich_text :content
  has_rich_text :draft_content

  # Validations
  validates :title, presence: true, unless: :draft_only?
  validates :content, presence: true, unless: :draft_only?

  # Scopes
  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_drafts, -> { where.not(draft_saved_at: nil) }

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

  def has_draft?
    draft_saved_at.present?
  end

  def draft_only?
    draft_saved_at.present? && published_at.nil? && title.nil?
  end

  # 下書きから公開
  def publish_from_draft!
    if has_draft?
      self.title = draft_title
      self.content = draft_content
      self.published_at = Time.current
      self.draft_title = nil
      self.draft_content = nil
      self.draft_saved_at = nil
      save
    end
  end

  # 下書きをクリア
  def clear_draft!
    update(
      draft_title: nil,
      draft_content: nil,
      draft_saved_at: nil
    )
  end
end
