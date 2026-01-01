class AddShowInNoticeAndPublishedToCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :calendar_events, :show_in_notice, :boolean, default: false
    add_column :calendar_events, :published, :boolean, default: true
    add_column :calendar_events, :notice_id, :bigint
    add_index :calendar_events, :notice_id
  end
end
