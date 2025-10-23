class AddDraftFieldsToNotices < ActiveRecord::Migration[8.0]
  def change
    add_column :notices, :draft_title, :string
    add_column :notices, :draft_saved_at, :datetime

    add_index :notices, :draft_saved_at
  end
end
