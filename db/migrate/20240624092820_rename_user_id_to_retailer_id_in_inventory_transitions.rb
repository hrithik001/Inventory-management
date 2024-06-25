class RenameUserIdToRetailerIdInInventoryTransitions < ActiveRecord::Migration[7.1]
  def change
    rename_column :inventory_transitions, :user_id, :retailer_id
  end
end
