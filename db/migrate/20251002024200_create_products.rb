class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description
      t.boolean :featured, default: false

      t.timestamps
    end

    add_index :products, :featured
  end
end
