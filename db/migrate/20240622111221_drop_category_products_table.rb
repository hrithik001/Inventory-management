class DropCategoryProductsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :category_products
  end
end
