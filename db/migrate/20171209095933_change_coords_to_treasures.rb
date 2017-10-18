class ChangeCoordsToTreasures < ActiveRecord::Migration[5.1]
  def change
    change_column :treasures, :lat, :decimal, precision: 10, scale: 6, null: true
    change_column :treasures, :lng, :decimal, precision: 10, scale: 6, null: true
  end
end
