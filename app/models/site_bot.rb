class SiteBot < ApplicationRecord
  belongs_to :site_user, dependent: :destroy
end
