class MainListener
  include DefaultMessage
  include Modules::DefaultOptions

  MAIN_PAGE = I18n.t('main_page').freeze
  RULES_PAGE = I18n.t('rules_page').freeze
  PRICE_LIST_PAGE = I18n.t('price_page').freeze
  REVERT_PAYMENT_PAGE = I18n.t('revert_page').freeze
  PAYMENT_CODE = 'payment_code'.freeze
  PAYMENT_CODE_FORMAT = /^[0-2][0-3]:\d/
  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform # rubocop:disable Metrics/AbcSize
    if user.allowed_messages.include? message.text
      if user.choosen_product_id.nil? # when product not choosen
        always_listen_messages
        price_listener
        ProductTitleListener.new(bot, message, user).perform
        SpecialMessageListener.new(bot, message, user).perform
      else
        always_listen_messages
        ProductListener.new(bot, message, user).perform
      end
    elsif (user.allowed_messages.include? PAYMENT_CODE) && (PAYMENT_CODE_FORMAT =~ message.text)
      ProductListener.new(bot, message, user).only_sell_treasure
    end
  end

  private

  def always_listen_messages
    case message.text
    when MAIN_PAGE
      Actions::Main.(nil, default_options)
    when RULES_PAGE
      Actions::Rules.(nil, default_options)
    end
  end

  def price_listener
    Actions::PriceList.(nil, default_options) if message.text == PRICE_LIST_PAGE
  end

  def main_page_responce
    bot.api.sendMessage(default_message(message, I18n.t('main', main_page_message_options)))
  end
end
