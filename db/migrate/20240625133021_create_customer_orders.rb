class CreateCustomerOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_orders do |t|
      t.datetime :delivery_date
      t.datetime :order_date
      t.datetime :expected_delivery_date
      t.integer :retailer_id
      t.integer :customer_id
      t.decimal :total_amount
      t.string :status

      t.timestamps
    end
    add_foreign_key :customer_orders, :users, column: :retailer_id
    add_foreign_key :customer_orders, :users, column: :customer_id
  end
end
