module Actions
  class SellTreasureFromBallance < Trailblazer::Operation
    include DefaultMessage

    step :check_user_ballance!
    success TrailblazerHelpers::Operations::SendTreasure
    success :update_user_ballance!
    success TrailblazerHelpers::Operations::ResetUserChooses
    success TrailblazerHelpers::Operations::AfterTreasureSoldActions
    success Nested(::Actions::Main, input: lambda do |options, **|
      {
        current_user: options['current_user'],
        bot: options['bot'],
        message: options['message']
      }
    end)

    def update_user_ballance!(_options, current_user:, treasure_price:, **)
      current_user.update(balance: current_user.balance - treasure_price)
    end

    def check_user_ballance!(options, current_user:, treasure:, **)
      options['treasure_price'] = TreasurePrice.call(treasure.product, treasure)
      current_user.balance >= options['treasure_price']
    end
  end
end
