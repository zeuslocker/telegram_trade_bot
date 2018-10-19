class User < ApplicationRecord
  belongs_to :site_bot
  enum choosen_location: Treasure::LOCATIONS
end
