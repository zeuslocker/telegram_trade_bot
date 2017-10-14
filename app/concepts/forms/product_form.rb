require 'reform/form/validation/unique_validator'

module Forms
  class ProductForm < ::Reform::Form
    properties :title, :price, :desc

    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :title, presence: true, unique: true
  end
end
