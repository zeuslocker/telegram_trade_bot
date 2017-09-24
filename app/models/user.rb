class User < ApplicationRecord
  enum choosen_location: Treasure::LOCATIONS
end
