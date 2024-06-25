class FixInventoryQuantityAvailable < ActiveRecord::Migration[7.1]
  def change
    rename_column :inventories, :quantity_avilable, :quantity_available
  end
end
