class AddSeasonalToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :seasonal, :boolean, default: false
    add_column :products, :featured_order, :integer
    add_column :products, :seasonal_order, :integer
    add_column :products, :published_at, :datetime

    add_index :products, :seasonal
    add_index :products, :featured
    add_index :products, :featured_order
    add_index :products, :seasonal_order
  end
end
