class TreasurePrice
  def self.call(*args)
    new(*args).perform
  end

  def initialize(product, treasure)
    @product = product
    @treasure = treasure
  end

  def perform
    product.price * treasure.amount.to_f
  end

  private

  attr_reader :product, :treasure
end
