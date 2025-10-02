class AddColumnsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :image_filename, :string, null: false, default: ''
    add_column :products, :category, :string
    add_column :products, :visible, :boolean, default: true
    add_column :products, :display_order, :integer, default: 0

    add_index :products, :visible
    add_index :products, :category
    add_index :products, :display_order

    # 既存データに対してデフォルト値を設定
    reversible do |dir|
      dir.up do
        Product.update_all(image_filename: 'placeholder.jpg')
      end
    end
  end
end
