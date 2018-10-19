class AlterBelongsSiteUserModels < ActiveRecord::Migration[5.1]
  def change
    add_reference(:pay_codes, :site_bot, foreign_key: true)
    add_reference(:products, :site_bot, foreign_key: true)
    add_reference(:users, :site_bot, foreign_key: true)
    remove_index(:users, :telegram_id)
    add_index(:users, :telegram_id)
  end
end
