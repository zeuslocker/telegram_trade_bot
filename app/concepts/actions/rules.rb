class Actions::Rules < Trailblazer::Operation
  include DefaultMessage

  success :send_responce

  def send_responce(_options, bot:, message:, **)
    bot.api.sendMessage(default_message(message, I18n.t('rules')))
  end
end
