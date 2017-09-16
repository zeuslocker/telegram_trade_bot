module DefaultMessage
  def default_message(message, text, reply_markup = nil)
    {
      parse_mode: 'HTML',
      chat_id: message.chat.id,
      text: text,
      reply_markup: reply_markup
    }.compact
  end
end
