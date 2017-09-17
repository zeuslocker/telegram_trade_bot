class AddChoosenLocationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :choosen_location, :integer
  end
end
