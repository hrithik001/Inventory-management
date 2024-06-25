class AddColumnToCustomerOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :customer_orders, :status, :string
  end
end
