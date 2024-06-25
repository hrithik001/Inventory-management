class CreateCustomerOrderVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_order_variants do |t|
      t.references :customer_order, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer :ordered_quantity
      t.integer :supplied_quantity

      t.timestamps
    end
  end
end
