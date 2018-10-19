require 'reform/form/validation/unique_validator'

module Forms
  class ProductForm < ::Reform::Form
    properties :title, :price, :desc, :site_bot_id

    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :title, presence: true, unique: true
    validates :site_bot_id, presence: true
  end
end
