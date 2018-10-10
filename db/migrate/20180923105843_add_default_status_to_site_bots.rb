class AddDefaultStatusToSiteBots < ActiveRecord::Migration[5.1]
  def change
    change_column :site_bots, :status, :integer, default: 0, null: false
  end
end
