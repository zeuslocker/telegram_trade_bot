class TrailblazerHelpers::Operations::SendTreasure
  extend DefaultMessage
  extend Uber::Callable

  def self.call(_options, bot:, message:, treasure:, **)
    bot.api.sendMessage(default_message(message, I18n.t('payment_found')))
    bot.api.sendMessage(default_message(message, treasure.description))
  end
end
