class AddApprovalDateToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :approval_date, :datetime
  end
end
