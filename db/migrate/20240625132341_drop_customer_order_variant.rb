class DropCustomerOrderVariant < ActiveRecord::Migration[7.1]
  def change
    drop_table :customer_order_variants
  end
end
