module PayHelpers
  extend DefaultMessage
  EASYPAY_WALLET_ID = Rails.application.secrets[:easypay_wallet_id].freeze
  EASYPAY_SIGN_IN_URL = URI.parse("https://easypay.ua/auth/signin")
  EASYPAY_ROOT_URL = "https://easypay.ua/"
  EASYPAY_LOGIN =  Rails.application.secrets[:easypay_login].freeze
  EASYPAY_PASSWORD = Rails.application.secrets[:easypay_password].freeze
  PAY_LOCK_TIME = 5

  def self.check_pay_code_locked?(current_user)
    current_user.pay_code_lock.present? &&
    current_user.pay_code_lock > (Time.current - PAY_LOCK_TIME.minutes)
  end

  def self.payment_not_found(bot, message, current_user)
    bot.api.sendMessage(default_message(message, I18n.t('payment_not_found')))
    current_user.update(allowed_messages: (current_user.allowed_messages << MainListener::HOW_TO_PAY_COMMAND))
    current_user.update(pay_code_lock: Time.current)
  end

  def self.pay_code_minutes_left(current_user)
    ((current_user.pay_code_lock - (Time.current - PAY_LOCK_TIME.minutes)) / 60).truncate
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

  def self.its_new_pay_code?(row)
    !PayCode.exists?(payed_at: DateTime.parse(row_get_date(row)),
                     term_code: row_get_term_code(row))
  end

  def self.save_pay_code(row)
    PayCode.create(payed_at: DateTime.parse(row_get_date(row)),
                   term_code: row_get_term_code(row))
  end
end
