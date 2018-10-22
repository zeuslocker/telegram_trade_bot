class SiteBot < ApplicationRecord
  belongs_to :site_user

  has_many :users, dependent: :destroy
  has_many :pay_codes, dependent: :destroy
  has_many :products, dependent: :destroy

  enum status: { disabled: 1, enabled: 0 }
end
