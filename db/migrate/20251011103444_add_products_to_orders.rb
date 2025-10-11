class AddProductsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :products, :json
  end
end
