module PayHelpers
  extend DefaultMessage
  EASYPAY_ROOT_URL = "https://partners.easypay.ua/"
  EASYPAY_SIGN_IN_URL = URI.parse("#{EASYPAY_ROOT_URL}auth/signin")
  PAY_LOCK_TIME = 2

  def self.check_pay_code_locked?(current_user)
    current_user.pay_code_lock.present? &&
    current_user.pay_code_lock > (Time.current - PAY_LOCK_TIME.minutes)
  end

  def self.payment_not_found(bot, message, current_user)
    bot.api.sendMessage(default_message(message, I18n.t('payment_not_found', pay_lock_time: PayHelpers::PAY_LOCK_TIME)))
    current_user.update(allowed_messages: (current_user.allowed_messages << MainListener::HOW_TO_PAY_COMMAND))
    current_user.update(pay_code_lock: Time.current)
  end

  def self.pay_code_minutes_left(current_user)
    ((current_user.pay_code_lock - (Time.current - (PAY_LOCK_TIME + 1).minutes)) / 60).truncate
  end

  def self.date_valid?(row, message)
    row_get_date(row)&.split&.last == message[0..4]
  end

  def self.row_get_sum(row)
    row&.css('td')&.at(2)&.children.text.to_f
  end

  def self.row_get_date(row)
    row&.at_css('td:first-child')&.children&.text
  end

  def self.row_get_term_code(row)
    row&.css('td')&.at(4)&.text&.split&.last
  end

  def self.code_valid?(row, message)
    row_get_term_code(row) == message[6..-1]
  end

  def self.its_new_pay_code?(row, site_bot_id)
    !PayCode.exists?(payed_at: DateTime.parse(row_get_date(row)),
                     term_code: row_get_term_code(row),
                     site_bot_id: site_bot_id)
  end

  def self.save_pay_code(row, site_bot_id)
    PayCode.create(payed_at: DateTime.parse(row_get_date(row)),
                   term_code: row_get_term_code(row),
                   site_bot_id: site_bot_id)
  end
end
