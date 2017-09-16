class Treasure < ApplicationRecord
  belongs_to :product
  LOCATIONS = [:galician, :livandovka, :suhiv, :lichakiv, :shevchenkiv, :frankiv].freeze
  enum location: LOCATIONS
end
