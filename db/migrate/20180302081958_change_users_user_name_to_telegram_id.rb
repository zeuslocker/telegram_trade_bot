class ChangeUsersUserNameToTelegramId < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :user_name, :string
    add_column :users, :telegram_id, :string, unique: true, null: false

    add_index :users, :telegram_id, unique: true
  end
end
