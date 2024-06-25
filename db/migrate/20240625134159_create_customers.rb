class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :contact
      t.string :address

      t.timestamps
    end
  end
end
