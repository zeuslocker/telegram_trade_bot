class AddChoosenProductIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :choosen_product_id, :integer
  end
end
