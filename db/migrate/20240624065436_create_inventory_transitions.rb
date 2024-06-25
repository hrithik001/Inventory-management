class CreateInventoryTransitions < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_transitions do |t|
      t.references :inventory, null: false, foreign_key: true
      t.string :transition_type
      t.integer :quantity
      t.datetime :transition_date
      t.references :variant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
