class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.datetime :delivery_date
      t.datetime :order_date
      t.datetime :expected_delivery_date
      t.integer :retailer_id
      t.integer :supplier_id
      t.string :status
      t.decimal :total_amount, precision: 10, scale: 2
      t.timestamps
    end

    add_foreign_key :orders, :users, column: :retailer_id
    add_foreign_key :orders, :users, column: :supplier_id
  end
end
