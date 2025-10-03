class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description
      t.boolean :is_featured, default: false
      t.boolean :is_seasonal, default: false
      t.integer :featured_order
      t.integer :seasonal_order
      t.boolean :published, default: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :products, :is_featured
    add_index :products, :is_seasonal
    add_index :products, :featured_order
    add_index :products, :seasonal_order
  end
end
