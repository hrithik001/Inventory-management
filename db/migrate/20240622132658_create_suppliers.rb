class CreateSuppliers < ActiveRecord::Migration[7.1]
  def change
    create_table :suppliers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :contact
      t.string :notes

      t.timestamps
    end
  end
end
