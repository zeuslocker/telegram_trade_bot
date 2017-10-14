class AddDescToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :desc, :text
  end
end
