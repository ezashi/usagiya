class AddDraftSavedAtToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :draft_saved_at, :datetime
    add_index :products, :draft_saved_at
  end
end
