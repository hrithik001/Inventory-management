class DropCustomerOrder < ActiveRecord::Migration[7.1]
  def change
    drop_table :customer_orders
  end
end
