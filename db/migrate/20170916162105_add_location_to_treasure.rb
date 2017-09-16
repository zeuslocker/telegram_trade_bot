class AddLocationToTreasure < ActiveRecord::Migration[5.1]
  def change
    add_column :treasures, :location, :integer, null: false
  end
end
