class AddAmountToTreasure < ActiveRecord::Migration[5.1]
  def change
    add_column :treasures, :amount, :float, null: false
  end
end
