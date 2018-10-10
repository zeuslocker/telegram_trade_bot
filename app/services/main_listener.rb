class MainListener
  include DefaultMessage
  include Modules::DefaultOptions

  MAIN_PAGE = I18n.t('main_page').freeze
  START_COMMAND = '/start'.freeze
  RULES_PAGE = I18n.t('rules_page').freeze
  HOW_TO_PAY_PAGE = I18n.t('how_to_pay').freeze
  HOW_TO_PAY_COMMAND = '/payments'.freeze
  PRICE_LIST_PAGE = I18n.t('price_page').freeze
  REVERT_PAYMENT_PAGE = I18n.t('revert_page').freeze
  PAYMENT_CODE = 'payment_code'.freeze
  PAYMENT_CODE_FORMAT = /^([0-9]|0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])_([1-9]\d*$)/
  PAY_FROM_BALANCE = I18n.t('pay_from_balance').freeze
  REPLENISH_BALANCE = I18n.t('replenish_balance').freeze
  attr_reader :bot, :message, :user, :site_bot

  def initialize(bot, message, user, site_bot)
    @bot = bot
    @message = message
    @user = user
    @site_bot = site_bot
  end

  def perform # rubocop:disable Metrics/AbcSize
    SpecialMessageListener.new(bot, message, user).perform if user.choosen_product_id.nil?
    if user.allowed_messages.include? message.text
      if user.choosen_product_id.nil? # when product not choosen
        always_listen_messages
        price_listener
        ProductTitleListener.new(bot, message, user).perform
      else
        always_listen_messages
        ProductListener.new(bot, message, user, site_bot).perform
      end
    elsif (user.allowed_messages.include? PAYMENT_CODE) && (PAYMENT_CODE_FORMAT =~ message.text) && user.choosen_product_id.nil?
      Actions::ReplenishBalance.call(nil, default_options)
    elsif user.allowed_messages.blank? || message.text == START_COMMAND
      Actions::Main.(nil, default_options)
      # elsif (user.allowed_messages.include? PAYMENT_CODE) && (PAYMENT_CODE_FORMAT =~ message.text)
      #  ProductListener.new(bot, message, user).only_sell_treasure
    end
  end

  private

  def always_listen_messages
    case message.text
    when MAIN_PAGE, REVERT_PAYMENT_PAGE, START_COMMAND
      Actions::Main.(nil, default_options)
    when RULES_PAGE
      Actions::Rules.(nil, default_options)
    when HOW_TO_PAY_PAGE, HOW_TO_PAY_COMMAND
      Actions::HowToPay.(nil, default_options)
    when REPLENISH_BALANCE
      Actions::ShowBalanceReplenishPayment.(nil, default_options)
    end
  end

  def price_listener
    Actions::PriceList.(nil, default_options) if message.text == PRICE_LIST_PAGE
  end

  def main_page_responce
    bot.api.sendMessage(default_message(message, I18n.t('main', main_page_message_options)))
  end
end
