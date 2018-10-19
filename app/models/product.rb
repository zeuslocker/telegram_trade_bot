class Product < ApplicationRecord
  belongs_to :site_bot
  has_many :treasures, dependent: :destroy
end
