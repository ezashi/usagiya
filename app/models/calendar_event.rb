class CalendarEvent < ApplicationRecord
  # Enums
  enum :event_type, {
    regular_holiday: 0,    # 定休日
    sales_start: 1,        # 商品販売開始日
    sales_end: 2,          # 販売終了日
    irregular_holiday: 3,  # 不定休
    other: 4,              # その他
    holiday: 5             # 休業日
  }

  # Associations
  belongs_to :notice, optional: true

  # Validations
  validates :event_type, presence: { message: "イベントタイプを選択してください" }
  validates :event_date, presence: { message: "日付を入力してください" }
  validates :title, presence: { message: "タイトルを入力してください" }, if: :title_required?

  # Scopes
  scope :by_month, ->(year, month) { where("EXTRACT(YEAR FROM event_date) = ? AND EXTRACT(MONTH FROM event_date) = ?", year, month) }
  scope :future, -> { where("event_date >= ?", Date.today) }
  scope :published, -> { where(published: true) }

  # Callbacks
  before_validation :set_default_title_and_color
  after_save :handle_notice_creation

  # イベント種類の選択肢
  def self.event_type_options
    {
      "定休日" => "regular_holiday",
      "休業日" => "holiday",
      "商品販売開始日" => "sales_start",
      "販売終了日" => "sales_end",
      "不定休" => "irregular_holiday",
      "その他" => "other"
    }
  end

  # イベント種類のラベル
  def event_type_label
    {
      "regular_holiday" => "定休日",
      "holiday" => "休業日",
      "sales_start" => "販売開始日",
      "sales_end" => "販売終了日",
      "irregular_holiday" => "不定休",
      "other" => "その他"
    }[event_type]
  end

  # イベント種類ごとの色
  def self.event_type_colors
    {
      "regular_holiday" => "#ef4444",   # 赤
      "holiday" => "#fca5a5",           # 薄紅色
      "sales_start" => "#f59e0b",       # 黄色
      "sales_end" => "#3b82f6",         # 青
      "irregular_holiday" => "#f472b6", # ピンク
      "other" => nil                    # カスタム
    }
  end

  def default_color
    self.class.event_type_colors[event_type]
  end

  # カレンダーに表示するタイトル
  def display_title
    case event_type
    when "regular_holiday"
      "定休日"
    when "holiday"
      "休業日"
    when "irregular_holiday"
      "不定休"
    else
      title.presence || event_type_label
    end
  end

  # タイトルが必要かどうか
  def title_required?
    %w[sales_start sales_end other].include?(event_type)
  end

  # お知らせ表示フラグ
  def show_in_notice?
    show_in_notice
  end

  # お知らせのプレビューテキスト生成
  def notice_preview_content
    if irregular_holiday?
      generate_irregular_holiday_content
    elsif description.present?
      description
    else
      nil
    end
  end

  # 不定休のお知らせテキスト生成
  def generate_irregular_holiday_content
    month = event_date.month

    # 同じ月の不定休をすべて取得
    irregular_holidays = CalendarEvent.irregular_holiday
                                      .where("EXTRACT(MONTH FROM event_date) = ?", month)
                                      .where("EXTRACT(YEAR FROM event_date) = ?", event_date.year)
                                      .order(:event_date)

    weekdays = %w[日 月 火 水 木 金 土]
    holiday_text = irregular_holidays.map do |h|
      "#{h.event_date.month}月#{h.event_date.day}日（#{weekdays[h.event_date.wday]}）"
    end.join("、")

    <<~TEXT.strip
      誠に勝手ながら、日曜日の定休日に加え不定休でお休みさせていただきます。

      不定休日は月ごとにホームページでお知らせいたします。

      #{month}月の不定休は、#{holiday_text}です。

      よろしくお願いいたします。
    TEXT
  end

  private

  def set_default_title_and_color
    # 色が設定されていない場合はデフォルト色を設定
    if color.blank?
      self.color = default_color || "#94a3b8"
    end

    # タイトルが不要なイベント種類の場合はデフォルトタイトルを設定
    unless title_required?
      self.title = event_type_label if title.blank?
    end
  end

  def handle_notice_creation
    # 不定休の場合は自動でお知らせを作成
    if irregular_holiday? && saved_change_to_id?
      create_or_update_irregular_holiday_notice
    # それ以外でshow_in_noticeがtrueで説明がある場合
    elsif show_in_notice? && description.present? && notice.nil?
      # 下書きとしてお知らせを作成（公開ボタンで公開する）
      create_draft_notice
    end
  end

  def create_or_update_irregular_holiday_notice
    month = event_date.month
    year = event_date.year

    # 既存の同じ月のお知らせを探す
    existing_notice = Notice.where("title LIKE ?", "#{month}月の不定休のお知らせ%")
                            .where("created_at >= ? AND created_at <= ?",
                                   Date.new(year, month, 1).beginning_of_day,
                                   Date.new(year, month, -1).end_of_day)
                            .first

    content = generate_irregular_holiday_content

    if existing_notice
      # 既存のお知らせを更新
      existing_notice.update(content: content)
    else
      # 新規お知らせを作成（自動公開）
      Notice.create!(
        title: "#{month}月の不定休のお知らせ",
        content: content,
        published_at: Time.current
      )
    end
  end

  def create_draft_notice
    new_notice = Notice.create!(
      title: title.presence || "営業カレンダーのお知らせ",
      content: description,
      draft_title: title.presence || "営業カレンダーのお知らせ",
      draft_content: description,
      draft_saved_at: Time.current
    )
    update_column(:notice_id, new_notice.id)
  end
end
