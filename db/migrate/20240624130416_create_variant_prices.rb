class CreateVariantPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :variant_prices do |t|
      t.decimal :base_price, precision: 10, scale: 2
      t.decimal :average_selling_price, precision: 10, scale: 2
      t.decimal :selling_price, precision: 10, scale: 2
      t.integer :variant_id
      # t.index :variant_id

      t.timestamps
    end
    add_index :variant_prices, :variant_id
  end
end
