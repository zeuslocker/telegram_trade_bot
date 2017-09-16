class CreateTreasures < ActiveRecord::Migration[5.1]
  def change
    create_table :treasures do |t|
      t.text :description, null: false
      t.decimal :lat, precision: 10, scale: 6, null: false
      t.decimal :lng, precision: 10, scale: 6, null: false
      t.references :product, foreign_key: true, null: false

      t.timestamps
    end
  end
end
