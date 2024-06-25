class AddRetailerToInventoryTransitions < ActiveRecord::Migration[7.1]
  def change
    add_reference :inventory_transitions, :user, null: false, foreign_key: true
  end
end
