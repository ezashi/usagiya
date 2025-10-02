class CreateCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_events do |t|
      t.integer :event_type, null: false, default: 0
      t.date :event_date, null: false
      t.text :description
      t.boolean :auto_notice, default: false

      t.timestamps
    end

    add_index :calendar_events, :event_date
    add_index :calendar_events, :event_type
  end
end
