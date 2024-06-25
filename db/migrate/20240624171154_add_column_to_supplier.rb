class AddColumnToSupplier < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :delivery_time_accuracy, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :suppliers, :order_accuracy, :decimal, precision: 5, scale: 2, default: 0.0
    
  end
end
