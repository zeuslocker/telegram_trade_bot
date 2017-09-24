class AddAllowedMessagesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :allowed_messages, :text, array: true, default: []
  end
end
