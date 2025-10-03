class CreateCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_events do |t|
      t.string :event_type, null: false # 定休日/休業日/販売開始日/販売終了日/不定休/その他
      t.string :title
      t.date :date, null: false
      t.text :description
      t.string :color
      t.boolean :show_in_notice, default: false
      t.boolean :published, default: false

      t.timestamps
    end

    add_index :calendar_events, :event_type
    add_index :calendar_events, :date
    add_index :calendar_events, :published
  end
end
