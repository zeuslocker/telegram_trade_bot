class AddLastAuthCredsToSiteBot < ActiveRecord::Migration[5.1]
  def change
    add_column :site_bots, :last_request_verification_token_for_form, :string
    add_column :site_bots, :last_cookie, :string
    add_column :site_bots, :wallet_id, :string, null: false
  end
end
