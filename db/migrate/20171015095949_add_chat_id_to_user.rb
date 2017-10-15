class AddChatIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :chat_id, :string, null: false
  end
end
