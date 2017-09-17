class Actions::Rules < Trailblazer::Operation
  include DefaultMessage

  success :keyboard_markup!
  success :send_responce!

  def send_responce!(_options, bot:, message:, keyboard_markup:, **)
    bot.api.sendMessage(default_message(message, I18n.t('rules'), keyboard_markup))
  end

  def keyboard_markup!(options, **)
    options['keyboard_markup'] = KeyboardMarkups::Entry.()
  end
end
