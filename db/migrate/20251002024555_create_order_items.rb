class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :product_type, null: false
      t.integer :quantity, null: false, default: 0
      t.integer :unit_price, null: false, default: 0

      t.timestamps
    end
  end
end
