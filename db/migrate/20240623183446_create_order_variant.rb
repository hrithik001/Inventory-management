class CreateOrderVariant < ActiveRecord::Migration[7.1]
  def change
    create_table :order_variants do |t|
      t.integer :ordered_quantity, null: false
      t.integer :supplied_quantity, null: false, default: 0
      t.references :order, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
