class CreateCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_events do |t|
      t.integer :event_type, null: false, default: 0  # 定休日/休業日/販売開始日/販売終了日/不定休/その他
      t.string :title
      t.date :event_date, null: false
      t.text :description
      t.string :color
      t.boolean :auto_notice, default: false

      t.timestamps
    end

    add_index :calendar_events, :event_type
    add_index :calendar_events, :event_date
  end
end
