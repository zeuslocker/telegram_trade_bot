class AddTermCodeToPayCode < ActiveRecord::Migration[5.1]
  def change
    add_column :pay_codes, :term_code, :string
  end
end
