class Actions::ReplenishBalance < Trailblazer::Operation
  include DefaultMessage
  step Callables::CheckPayCodeLock
  success Nested(Operations::EasyPayHistory, input: lambda do |options, **|
    {
      site_bot: options['site_bot'],
      bot: options['bot'],
      message: options['message']
    }
  end,
  output: ->(options, mutable_data:, **) do
    {
      'pay_history_page' => mutable_data['pay_history_page']
    }
  end)
  success :payment_setup
  success Nested(::Actions::Main, input: lambda do |options, **|
    {
      current_user: options['current_user'],
      bot: options['bot'],
      message: options['message']
    }
  end)

  def payment_setup(_options, pay_history_page:, message:, bot:, current_user:, **)
    pay_history_page.css('table.table-layout tr').each do |row|
      return PayHelpers.save_pay_code(row) && update_user_balance(current_user, row, bot, message) && true if
             PayHelpers.date_valid?(row, message.text) &&
             PayHelpers.code_valid?(row, message.text) &&
             PayHelpers.its_new_pay_code?(row)
    end
    PayHelpers.payment_not_found(bot, message, current_user)
  end

  def update_user_balance(user, row, bot, message)
    user.update(balance: user.balance + PayHelpers.row_get_sum(row))
    bot.api.sendMessage(default_message(message, I18n.t('balance_replenished')))
  end
end
