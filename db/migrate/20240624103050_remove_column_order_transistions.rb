class RemoveColumnOrderTransistions < ActiveRecord::Migration[7.1]
  def change
    # remove_reference :order_variants, :inventory_id, foreign_key: true
  end
end
