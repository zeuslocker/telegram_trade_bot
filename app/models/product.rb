class Product < ApplicationRecord
  has_many :treasures, dependent: :destroy
end
