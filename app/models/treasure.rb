class Treasure < ApplicationRecord
  belongs_to :product
  LOCATIONS = %i[galician livandovka suhiv lichakiv shevchenkiv frankiv].freeze
  enum location: LOCATIONS
end
