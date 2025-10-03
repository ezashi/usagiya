class CreateNotices < ActiveRecord::Migration[7.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.boolean :published, default: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :notices, :published
    add_index :notices, :published_at
  end
end
