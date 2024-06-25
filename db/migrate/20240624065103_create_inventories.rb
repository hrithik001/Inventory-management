class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.references :variant, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :quantity_avilable
      t.integer :minimum_stock_level

      t.timestamps
    end
  end
end
