module Forms
  class TreasureForm < ::Reform::Form
    property :description
    property :lat
    property :lng
    property :product_id
    property :amount
    property :location

    validates :description, presence: true
    validates :product_id, presence: true
    validates :amount, presence: true
    validates :location, presence: true
  end
end
