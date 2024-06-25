class CreateSupplierMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :supplier_metrics do |t|
      t.references :supplier, null: false, foreign_key: true
      t.decimal :delivery_time_rating ,precision: 5, scale: 2, default: 0.0
      t.decimal :order_accuracy_rating , precision: 5, scale: 2, default: 0.0
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
