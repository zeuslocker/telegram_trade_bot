class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_name, unique: true, null: false
      t.float :balance, default: 0, null: false
      t.float :total_order_price, default: 0, null: false

      t.timestamps
    end

    add_index :users, :user_name, unique: true
  end
end
