class AddChoosenTreasureToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :choosen_treasure_id, :integer
  end
end
