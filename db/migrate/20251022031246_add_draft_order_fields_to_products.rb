class AddDraftOrderFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :draft_featured_order, :integer
    add_column :products, :draft_seasonal_order, :integer

    add_index :products, :draft_featured_order
    add_index :products, :draft_seasonal_order
  end
end
