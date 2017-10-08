class Treasure < ApplicationRecord
  belongs_to :product
  LOCATIONS = %i[galician livandovka suhiv lichakiv shevchenkiv frankiv].freeze
  STATUSES = %i[available sold].freeze
  enum location: LOCATIONS
  enum status: STATUSES
end
