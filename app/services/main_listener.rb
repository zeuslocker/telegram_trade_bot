class MainListener
  include DefaultMessage

  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform
    case message.text
    when '🎅 Главная'
      Actions::Main.call({}, 'bot' => bot, 'current_user' => user, 'message' => message)
    when '😰 Правила'
      bot.api.sendMessage(default_message(message, I18n.t('rules')))
    when '💶 Прайс лист'
      bot.api.sendMessage(default_message(message, PriceList.call))
    end
  end

  private

  def main_page_responce
    bot.api.sendMessage(default_message(message, I18n.t('main', main_page_message_options)))
  end
end
