class CalendarEvent < ApplicationRecord
  # Enums
  enum :event_type, {
    regular_holiday: 0,      # 定休日
    sales_start: 1,          # 商品販売開始日
    sales_end: 2,            # 販売終了日
    irregular_holiday: 3,    # 不定休
    other: 4                 # その他
  }, prefix: true

  # Validations
  validates :event_type, presence: { message: "イベントタイプを選択してください" }
  validates :event_date, presence: { message: "日付を入力してください" }

  # Scopes
  scope :by_month, ->(year, month) { where("EXTRACT(YEAR FROM event_date) = ? AND EXTRACT(MONTH FROM event_date) = ?", year, month) }
  scope :future, -> { where("event_date >= ?", Date.today) }

  # Callbacks
  after_create :create_notice_if_needed

  def self.event_type_options
    {
      "定休日" => "regular_holiday",
      "商品販売開始日" => "sales_start",
      "販売終了日" => "sales_end",
      "不定休" => "irregular_holiday",
      "その他" => "other"
    }
  end

  private

  def create_notice_if_needed
    if irregular_holiday? && auto_notice?
      create_irregular_holiday_notice
    elsif auto_notice? && description.present?
      create_custom_notice
    end
  end

  def create_irregular_holiday_notice
    month = event_date.month
    irregular_holidays = CalendarEvent.irregular_holiday
                                      .where("EXTRACT(MONTH FROM event_date) = ?", month)
                                      .order(:event_date)

    holiday_text = irregular_holidays.map do |holiday|
      "#{holiday.event_date.month}月#{holiday.event_date.day}日（#{%w[日 月 火 水 木 金 土][holiday.event_date.wday]}）"
    end.join("、")

    content = <<~TEXT
      誠に勝手ながら、日曜日の定休日に加え不定休でお休みさせていただきます。
      不定休日は月ごとにホームページでお知らせいたします。

      #{month}月の不定休は、#{holiday_text}です。

      よろしくお願いいたします。
    TEXT

    Notice.create!(
      title: "#{month}月の不定休のお知らせ",
      content: content,
      published_at: Time.current
    )
  end

  def create_custom_notice
    Notice.create!(
      title: "営業カレンダーのお知らせ",
      content: description,
      published_at: Time.current
    )
  end
end
