class AddPublishedToNotices < ActiveRecord::Migration[8.0]
  def change
    add_column :notices, :published, :boolean, default: false
    add_index :notices, :published
  end
end
