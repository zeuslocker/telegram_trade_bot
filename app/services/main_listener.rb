class MainListener
  include DefaultMessage
  include Modules::DefaultOptions

  MAIN_PAGE = '🎅 Главная'.freeze
  RULES_PAGE = '😰 Правила'.freeze
  PRICE_LIST_PAGE = '💶 Прайс лист'.freeze

  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform # rubocop:disable Metrics/AbcSize
    case message.text
    when MAIN_PAGE
      Actions::Main.(nil, default_options)
    when RULES_PAGE
      Actions::Rules.(nil, default_options)
    when PRICE_LIST_PAGE
      Actions::PriceList.(nil, default_options)
    end
  end

  private

  def main_page_responce
    bot.api.sendMessage(default_message(message, I18n.t('main', main_page_message_options)))
  end
end
