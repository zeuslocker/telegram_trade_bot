class Callables::CheckPayCodeLock
  extend DefaultMessage
  extend Uber::Callable

  def self.call(_options, current_user:, bot:, message:, **)
    if PayHelpers.check_pay_code_locked?(current_user)
      bot.api.sendMessage(
        default_message(message, I18n.t('wait_for_pay_code_lock', minutes: PayHelpers.pay_code_minutes_left(current_user)))
      )
      return false
    end
    true
  end
end
