class KeyboardMarkups::Treasures < Base
  def initialize(product_price:, treasures:, one_time_keyboard: true)
    super
    @buttons = treasures.each_slice(2) do |x, y|
      ["#{x.amount} за #{x.amount * product_price}грн. ##{x.id}", "#{y.amount} за #{y.amount * product_price}грн. ##{y.id}"]
    end
  end
end
