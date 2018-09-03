class CreateSiteBots < ActiveRecord::Migration[5.1]
  def change
    create_table :site_bots do |t|
      t.jsonb :secret_commands, null: false
      t.references :site_user, foreign_key: true
      t.integer :status
      t.float :total_income
      t.string :easy_number
      t.string :easy_password
      t.string :tg_token

      t.timestamps
    end
    add_index :site_bots, :tg_token, unique: true
  end
end
