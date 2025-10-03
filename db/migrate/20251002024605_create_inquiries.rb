class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.text :content, null: false
      t.string :captcha_token
      t.boolean :read, default: false

      t.timestamps
    end

    add_index :inquiries, :read
    add_index :inquiries, :created_at
  end
end
