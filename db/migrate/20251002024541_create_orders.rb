class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    # Ordersテーブルの作成
    create_table :orders do |t|
      # 注文者情報
      t.string :customer_name, null: false
      t.string :postal_code, null: false
      t.string :address, null: false
      t.string :phone, null: false
      t.string :email, null: false

      # 送り先情報
      t.boolean :same_address, default: true
      t.string :delivery_name
      t.string :delivery_postal_code
      t.string :delivery_address
      t.string :delivery_phone

      # 注文情報
      t.integer :total_amount, default: 0

      # 支払い・配送情報
      t.string :payment_method, null: false
      t.date :delivery_date
      t.string :delivery_time
      t.string :wrapping_type, null: false
      t.text :notes

      # ステータス
      t.string :status, default: 'pending'

      t.timestamps
    end

    add_index :orders, :email
    add_index :orders, :status
    add_index :orders, :created_at

    # OrderItemsテーブルの作成
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :product_name, null: false
      t.string :product_type, null: false
      t.integer :quantity, null: false, default: 0
      t.integer :unit_price, null: false
      t.integer :subtotal, null: false

      t.timestamps
    end

    add_index :order_items, [:order_id, :product_type], unique: true
  end
end
