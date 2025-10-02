class Notice < ApplicationRecord
  # Validations
  validates :title, presence: { message: "タイトルを入力してください" }
  validates :content, presence: { message: "内容を入力してください" }

  # Scopes
  scope :published, -> { where("published_at <= ?", Time.current).order(published_at: :desc) }
  scope :recent, -> { order(published_at: :desc) }

  # Callbacks
  before_validation :set_published_at, on: :create

  private

  def set_published_at
    self.published_at ||= Time.current
  end
end
