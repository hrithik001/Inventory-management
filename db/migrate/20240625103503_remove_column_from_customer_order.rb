class RemoveColumnFromCustomerOrder < ActiveRecord::Migration[7.1]
  def change
    remove_column :customer_orders , :status
  end
end
