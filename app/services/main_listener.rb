class MainListener
  include DefaultMessage
  include Modules::DefaultOptions

  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform # rubocop:disable Metrics/AbcSize
    case message.text
    when '🎅 Главная'
      Actions::Main.call(nil, default_options)
    when '😰 Правила'
      Actions::Rules.call(nil, default_options)
    when '💶 Прайс лист'
      bot.api.sendMessage(default_message(message, PriceList.call))
    end
  end

  private

  def main_page_responce
    bot.api.sendMessage(default_message(message, I18n.t('main', main_page_message_options)))
  end
end
