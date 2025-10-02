class CreateNotices < ActiveRecord::Migration[8.0]
  def change
    create_table :notices do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :notices, :published_at
  end
end
