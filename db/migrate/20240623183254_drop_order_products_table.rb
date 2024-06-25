class DropOrderProductsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :order_products
  end
end
