class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      # ご注文者様情報
      t.string :customer_name, null: false
      t.string :postal_code, null: false
      t.text :address, null: false
      t.string :phone, null: false
      t.string :email, null: false

      # 配送先情報
      t.boolean :same_address, default: false
      t.string :delivery_name
      t.string :delivery_postal_code
      t.text :delivery_address
      t.string :delivery_phone

      # 注文情報
      t.integer :total_amount, default: 0
      t.string :payment_method, null: false
      t.date :delivery_date
      t.string :delivery_time
      t.string :wrapping_type, null: false
      t.text :notes

      # ステータス管理
      t.string :status, default: 'pending'

      t.timestamps
    end

    add_index :orders, :email
    add_index :orders, :created_at
    add_index :orders, :status
  end
end
