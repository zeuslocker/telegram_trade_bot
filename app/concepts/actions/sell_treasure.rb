require 'net/http'
require 'uri'
require 'csv'

class Actions::SellTreasure < Trailblazer::Operation
  include DefaultMessage
  step :payment_sign_in
  step :build_report
  step :setup_csv_payment!
  step :payment_present?

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
      "login" => "380630348377",
      "password" => "zeusxlogan1715",
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    # response.code
    # response.body

    binding.pry
    options['cookie'] = response['Set-Cookie']
  end

  def build_report(options, cookie:, **)
    require 'net/http'
    require 'uri'

    uri = URI.parse("https://easypay.ua/wallets/buildreport?walletId=612304&month=9&year=2017")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    request["Accept-Language"] = "en-US,en;q=0.5"
    request["Cache-Control"] = "no-cache"
    request["Connection"] = "keep-alive"
    request["Cookie"] = cookie
    request["Host"] = "easypay.ua"
    request["Postman-Token"] = "6d22aee7-9407-baaa-f843-dfc8f14b73ef"
    request["Referer"] = "https://easypay.ua/"
    request["Upgrade-Insecure-Requests"] = "1"
    request["User-Agent"] = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0"
    request.set_form_data(
      "__RequestVerificationToken" => "nyot0RO4N0O-3IDQ41oAG5ZhLHEj-3PG8eqSZ4JWokZUCIB5ie8YXyAsaVpqI1YPdJyvU4WyOzpM-oeGrRxS6PzUm0_kvJl39_PfjfF76IA1",
      "login" => "380630348377",
      "password" => "zeusxlogan1715",
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    true
    # response.code
    # response.body
  end
# "https://easypay.ua/wallets/buildreport?walletId=612304&month=#{time_current.month}&year=#{time_current.year}"
  def setup_csv_payment!(options, bot:, message:, cookie:, **)
    bot.api.sendMessage(default_message(message, I18n.t('payment_checking')))
    time_current = Time.current
    uri = URI.parse("https://easypay.ua/wallets/exportcsv?walletId=612304&month=#{time_current.month}&year=#{time_current.year}")
    request = Net::HTTP::Get.new(uri)
    request["Cookie"] = cookie
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    binding.pry
    options['csv_string'] = response.body.force_encoding("cp1251").encode("utf-8", undef: :replace)
  end

  def payment_present?(options, csv_string:, **)
    CSV.parse(csv_string) do |row|
      p row
    end
  end
end
