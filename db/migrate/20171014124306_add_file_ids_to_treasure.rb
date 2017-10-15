class AddFileIdsToTreasure < ActiveRecord::Migration[5.1]
  def change
    add_column :treasures, :file_ids, :text, array: true, default: []
  end
end
