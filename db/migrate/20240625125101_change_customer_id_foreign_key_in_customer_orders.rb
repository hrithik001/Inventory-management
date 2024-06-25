class ChangeCustomerIdForeignKeyInCustomerOrders < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :customer_orders, :customers
    
    # Add the new foreign key pointing to the users table
    add_foreign_key :customer_orders, :users, column: :customer_id
  end
end
