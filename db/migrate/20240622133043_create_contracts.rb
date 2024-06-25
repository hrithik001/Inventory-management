class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.references :supplier, null: false, foreign_key: true
      t.string :signature
     
      t.datetime :valid_upto

      t.timestamps
    end
  end
end
