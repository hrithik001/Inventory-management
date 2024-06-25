class RemoveInventoryIdFromOrderVariants < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :inventory_transitions, column: :inventory_id
    remove_column :inventory_transitions, :inventory_id, :integer
  end
end
