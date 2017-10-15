class TrailblazerHelpers::Operations::SendTreasure
  extend DefaultMessage
  extend Uber::Callable

  def self.call(_options, bot:, message:, treasure:, **)
    bot.api.sendMessage(default_message(message, I18n.t('payment_found')))
    bot.api.sendMessage(default_message(message, treasure.description))
    treasure.file_ids.each do |file_id|
      bot.api.send_document(chat_id: message.chat.id, document: file_id)
    end
  end
end
