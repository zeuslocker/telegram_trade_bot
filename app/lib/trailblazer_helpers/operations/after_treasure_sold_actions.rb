class TrailblazerHelpers::Operations::AfterTreasureSoldActions
  extend Uber::Callable

  def self.call(options, treasure:, current_user:, treasure_price:, **)
    treasure.update(status: :sold)
    current_user.update(total_order_price: current_user.total_order_price + treasure_price)
  end
end
