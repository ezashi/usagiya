class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :product_type, null: false
      t.integer :quantity, default: 0, null: false

      t.timestamps
    end

    add_index :order_items, [ :order_id, :product_type ]
  end
end
