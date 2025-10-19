class AddDraftContentToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :draft_name, :string
    add_column :products, :draft_price, :integer
    add_column :products, :draft_description, :text
    add_column :products, :draft_featured, :boolean, default: false
    add_column :products, :draft_seasonal, :boolean, default: false
  end
end
