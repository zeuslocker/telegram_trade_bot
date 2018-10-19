require 'net/http'
require 'uri'
require 'csv'

class Actions::SellTreasure < Trailblazer::Operation
  include DefaultMessage
  step :check_pay_code_lock!
  step Callables::EasypayPaymentSignIn
  step Callables::EasypayPayHistory
  step :setup_treasure_price!
  step :payment_present?
  success TrailblazerHelpers::Operations::SendTreasure
  success TrailblazerHelpers::Operations::ResetUserChooses
  success TrailblazerHelpers::Operations::AfterTreasureSoldActions
  success Nested(::Actions::Main, input: lambda do |options, **|
    {
      current_user: options['current_user'],
      bot: options['bot'],
      message: options['message']
    }
  end)

  def check_pay_code_lock!(_options, current_user:, bot:, message:, **)
    if PayHelpers.check_pay_code_locked?(current_user)
      bot.api.sendMessage(
        default_message(message, I18n.t('wait_for_pay_code_lock', minutes: PayHelpers.pay_code_minutes_left(current_user)))
      )
      return false
    end
    true
  end

  def setup_treasure_price!(options, treasure:, **)
    options['treasure_price'] = TreasurePrice.call(treasure.product, treasure)
  end

  def payment_present?(_options, pay_history_page:, message:, treasure:, treasure_price:, bot:, current_user:, **)
    pay_history_page.css('table.table-layout tr').each do |row|
      return PayHelpers.save_pay_code(row) && update_user_balance(current_user, row, treasure_price) && true if
             PayHelpers.date_valid?(row, message.text) &&
             PayHelpers.code_valid?(row, message.text) &&
             PayHelpers.its_new_pay_code?(row) &&
             sum_valid?(row, treasure_price, bot, message, current_user)
    end
    payment_not_found(bot, message, current_user)
    false
  end

  def update_user_balance(user, row, treasure_price)
    user.update(balance: (user.balance + PayHelpers.row_get_sum(row) - treasure_price))
  end

  def payment_not_found(bot, message, current_user)
    bot.api.sendMessage(default_message(message, I18n.t('payment_not_found', pay_lock_time: PayHelpers::PAY_LOCK_TIME)))
    current_user.update(allowed_messages: (current_user.allowed_messages << MainListener::HOW_TO_PAY_COMMAND))
    current_user.update(pay_code_lock: Time.current)
  end

  def sum_valid?(row, treasure_price, bot, message, current_user)
    result = PayHelpers.row_get_sum(row) >= treasure_price
    bot.api.sendMessage(default_message(message, I18n.t('payment_sum_invalid'))) unless result
    current_user.update(balance: PayHelpers.row_get_sum(row))
    result
  end
end
