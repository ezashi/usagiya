class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      # 注文者情報
      t.string :orderer_name, null: false
      t.string :orderer_postal_code, null: false
      t.string :orderer_address, null: false
      t.string :orderer_phone, null: false
      t.string :orderer_email, null: false

      # 送り先情報
      t.boolean :same_address, default: true
      t.string :recipient_name
      t.string :recipient_postal_code
      t.string :recipient_address
      t.string :recipient_phone

      # 注文商品
      t.integer :mochipai_6, default: 0
      t.integer :mochipai_8, default: 0
      t.integer :mochipai_10, default: 0
      t.integer :mochipai_12, default: 0
      t.integer :mochipai_15, default: 0
      t.integer :mochipai_20, default: 0

      # 支払い・配送情報
      t.integer :total_price
      t.string :payment_method, null: false
      t.date :delivery_date
      t.string :delivery_time
      t.string :wrapping_type, null: false
      t.text :notes

      # ステータス
      t.string :status, default: 'pending' # pending/confirmed/shipped/completed/cancelled

      t.timestamps
    end

    add_index :orders, :orderer_email
    add_index :orders, :status
    add_index :orders, :created_at
  end
end
