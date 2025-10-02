class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false
      t.string :postal_code, null: false
      t.string :address, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :delivery_name
      t.string :delivery_postal_code
      t.string :delivery_address
      t.string :delivery_phone
      t.boolean :same_address, default: true
      t.integer :payment_method, null: false
      t.date :delivery_date
      t.string :delivery_time
      t.string :wrapping_type
      t.text :notes
      t.integer :total_amount, default: 0

      t.timestamps
    end

    add_index :orders, :email
    add_index :orders, :created_at
  end
end
