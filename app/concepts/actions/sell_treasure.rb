require 'net/http'
require 'uri'
require 'csv'

class Actions::SellTreasure < Trailblazer::Operation
  WALLET_ID = 612304
  LOGIN = '380630348377'.freeze
  PASSWORD = 'zeusxlogan1715'.freeze
  PAY_LOCK_TIME = 5

  include DefaultMessage
  step :check_pay_code_lock!
  step :payment_sign_in
  step :build_report
  step :setup_treasure_price!
  step :payment_present?
  success TrailblazerHelpers::Operations::SendTreasure
  success TrailblazerHelpers::Operations::ResetUserChooses
  success TrailblazerHelpers::Operations::AfterTreasureSoldActions
  success Nested(::Actions::Main, input: ->(options, **) do
    {
      current_user: options['current_user'],
      bot: options['bot'],
      message: options['message']
    }
  end)

  def check_pay_code_lock!(options, current_user:, bot:, message:, **)
    if check_pay_code_lock_condition(current_user)
      bot.api.sendMessage(
        default_message(message, I18n.t('wait_for_pay_code_lock', minutes: pay_code_minutes_left(current_user)))
      )
      return false
    end
    true
  end

  def payment_sign_in(options, **)
    uri = URI.parse("https://easypay.ua/auth/signin")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Host"] = "easypay.ua"
    request["User-Agent"] = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    request["Accept-Language"] = "en-US,en;q=0.5"
    request["Referer"] = "https://easypay.ua/"
    request["Cookie"] = "__utma=207498828.1814598634.1506022344.1506022344.1506022344.1; __utmz=207498828.1506022344.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); UrlReferrer=https://www.google.com.ua/; Locale=ru; _ga=GA1.2.1814598634.1506022344; _ym_uid=1506022378587758705; _gid=GA1.2.1864427035.1506756030; SID=xhoysydcbwdqdgtw2goamnwt; __RequestVerificationToken=pnX32MQgSU1ZWeW15DEhDw6W7ek_69F-2oleCBJTg0W9u04XzjuhElnbxuznOogA8inHKapTgwNxIWgkcUqky50Of7RBz3hB7zXBeoCxeXQ1; uechat_20410_pages_count=1; uechat_20410_first_time=1506769997169; _gat_UA-16800449-1=1"
    request["Connection"] = "keep-alive"
    request["Upgrade-Insecure-Requests"] = "1"
    request.set_form_data(
      "__RequestVerificationToken" => "nyot0RO4N0O-3IDQ41oAG5ZhLHEj-3PG8eqSZ4JWokZUCIB5ie8YXyAsaVpqI1YPdJyvU4WyOzpM-oeGrRxS6PzUm0_kvJl39_PfjfF76IA1",
      "login" => LOGIN,
      "password" => PASSWORD,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    # response.code
    # response.body
    options['cookie'] = response['Set-Cookie']
  end

  def build_report(options, bot:, message:, **)
    bot.api.sendMessage(default_message(message, I18n.t('payment_checking')))
    time_current = Time.current
    uri = URI.parse("https://easypay.ua/wallets/buildreport?walletId=#{WALLET_ID}&month=#{time_current.month}&year=#{time_current.year}")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    request["Accept-Language"] = "en-US,en;q=0.5"
    request["Cache-Control"] = "no-cache"
    request["Connection"] = "keep-alive"
    request["Cookie"] = "__utma=207498828.1814598634.1506022344.1506022344.1506022344.1; __utmz=207498828.1506022344.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); UrlReferrer=https://www.google.com.ua/; Locale=ru; _ga=GA1.2.1814598634.1506022344; _ym_uid=1506022378587758705; _gid=GA1.2.1864427035.1506756030; SID=xhoysydcbwdqdgtw2goamnwt; __RequestVerificationToken=pnX32MQgSU1ZWeW15DEhDw6W7ek_69F-2oleCBJTg0W9u04XzjuhElnbxuznOogA8inHKapTgwNxIWgkcUqky50Of7RBz3hB7zXBeoCxeXQ1; uechat_20410_pages_count=1; uechat_20410_first_time=1506769997169; _gat_UA-16800449-1=1"
    request["Host"] = "easypay.ua"
    request["Postman-Token"] = "6d22aee7-9407-baaa-f843-dfc8f14b73ef"
    request["Referer"] = "https://easypay.ua/"
    request["Upgrade-Insecure-Requests"] = "1"
    request["User-Agent"] = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0"
    request.set_form_data(
      "__RequestVerificationToken" => "nyot0RO4N0O-3IDQ41oAG5ZhLHEj-3PG8eqSZ4JWokZUCIB5ie8YXyAsaVpqI1YPdJyvU4WyOzpM-oeGrRxS6PzUm0_kvJl39_PfjfF76IA1",
      "login" => LOGIN,
      "password" => PASSWORD,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    options['response_body'] = Nokogiri::HTML(response.body.force_encoding('UTF-8'))
  end

  def setup_treasure_price!(options, treasure:, **)
    options['treasure_price'] = TreasurePrice.call(treasure.product, treasure)
  end

  def payment_present?(options, response_body:, message:, treasure:, treasure_price:, bot:, current_user:, **)
    response_body.css('table.table-layout tr').each do |row|
      return save_pay_code(row) && update_user_balance(current_user, row, treasure_price) && true if date_valid?(row, message.text) &&
                     code_valid?(row, message.text) &&
                     its_new_pay_code?(row) &&
                     sum_valid?(row, treasure_price, bot, message, current_user)
    end
    payment_not_found(bot, message, current_user)
    false
  end

  def update_user_balance(user, row, treasure_price)
    user.update(balance: (user.balance + row_get_sum(row) - treasure_price))
  end

  def payment_not_found(bot, message, current_user)
    bot.api.sendMessage(default_message(message, I18n.t('payment_not_found')))
    current_user.update(allowed_messages: (current_user.allowed_messages << MainListener::HOW_TO_PAY_COMMAND))
    current_user.update(pay_code_lock: Time.current)
  end

  def date_valid?(row, message)
    row_get_date(row)&.split&.last == message[0..4]
  end

  def code_valid?(row, message)
    row_get_term_code(row) == message[6..-1]
  end

  def sum_valid?(row, treasure_price, bot, message, current_user)
    result = row_get_sum(row) >= treasure_price
    bot.api.sendMessage(default_message(message, I18n.t('payment_sum_invalid'))) if !result
    current_user.update(balance: row_get_sum(row))
    result
  end

  def check_pay_code_lock_condition(current_user)
    current_user.pay_code_lock.present? &&
    current_user.pay_code_lock > (Time.current - PAY_LOCK_TIME.minutes)
  end

  def pay_code_minutes_left(current_user)
    ((current_user.pay_code_lock - (Time.current - PAY_LOCK_TIME.minutes)) / 60).truncate
  end

  def row_get_date(row)
    row&.at_css('td:first-child')&.children&.text
  end

  def row_get_sum(row)
    row&.css('td')&.at(2)&.children.text.to_f
  end

  def row_get_term_code(row)''
    row&.css('td')&.at(4)&.text&.split&.last
  end

  def save_pay_code(row)
    PayCode.create(payed_at: DateTime.parse(row_get_date(row)),
                   term_code: row_get_term_code(row))
  end

  def its_new_pay_code?(row)
    !PayCode.exists?(payed_at: DateTime.parse(row_get_date(row)),
                     term_code: row_get_term_code(row))
  end
end
