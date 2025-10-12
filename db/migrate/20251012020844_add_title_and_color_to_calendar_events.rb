class AddTitleAndColorToCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :calendar_events, :title, :string
    add_column :calendar_events, :color, :string
  end
end
