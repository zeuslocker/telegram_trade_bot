class SiteBot < ApplicationRecord
  belongs_to :site_user

  enum status: { disabled: 0, enabled: 1 }
end
