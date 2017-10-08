class CreatePayCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :pay_codes do |t|
      t.datetime :payed_at

      t.timestamps
    end
  end
end
