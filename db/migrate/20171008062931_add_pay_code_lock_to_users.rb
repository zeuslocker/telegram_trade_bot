class AddPayCodeLockToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pay_code_lock, :datetime
  end
end
