class AddDraftContentToNotices < ActiveRecord::Migration[8.0]
  def change
    add_column :notices, :draft_content, :text
  end
end
