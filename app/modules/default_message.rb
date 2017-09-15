module DefaultMessage
  def default_message(message, text)
    {
      parse_mode: 'HTML',
      chat_id: message.chat.id,
      text: text
    }
  end
end
