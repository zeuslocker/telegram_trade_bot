class Callables::EasypayPayHistory
  extend DefaultMessage
  extend Uber::Callable

  def self.call(options, bot:, message:, **)
    bot.api.sendMessage(default_message(message, I18n.t('payment_checking')))
    time_current = Time.current
    uri = URI.parse("https://easypay.ua/wallets/buildreport?walletId=#{PayHelpers::EASYPAY_WALLET_ID}&month=#{time_current.month}&year=#{time_current.year}")
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/x-www-form-urlencoded'
    request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    request['Accept-Language'] = 'en-US,en;q=0.5'
    request['Cache-Control'] = 'no-cache'
    request['Connection'] = 'keep-alive'
    request['Cookie'] = '__utma=207498828.1814598634.1506022344.1506022344.1506022344.1; __utmz=207498828.1506022344.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); UrlReferrer=https://www.google.com.ua/; Locale=ru; _ga=GA1.2.1814598634.1506022344; _ym_uid=1506022378587758705; _gid=GA1.2.1864427035.1506756030; SID=xhoysydcbwdqdgtw2goamnwt; __RequestVerificationToken=pnX32MQgSU1ZWeW15DEhDw6W7ek_69F-2oleCBJTg0W9u04XzjuhElnbxuznOogA8inHKapTgwNxIWgkcUqky50Of7RBz3hB7zXBeoCxeXQ1; uechat_20410_pages_count=1; uechat_20410_first_time=1506769997169; _gat_UA-16800449-1=1'
    request['Host'] = 'easypay.ua'
    request['Referer'] = PayHelpers::EASYPAY_ROOT_URL
    request['Upgrade-Insecure-Requests'] = '1'
    request['User-Agent'] = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0'
    request.set_form_data(
      '__RequestVerificationToken' => 'nyot0RO4N0O-3IDQ41oAG5ZhLHEj-3PG8eqSZ4JWokZUCIB5ie8YXyAsaVpqI1YPdJyvU4WyOzpM-oeGrRxS6PzUm0_kvJl39_PfjfF76IA1',
      'login' => PayHelpers::EASYPAY_LOGIN,
      'password' => PayHelpers::EASYPAY_PASSWORD
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    options['pay_history_page'] = Nokogiri::HTML(response.body.force_encoding('UTF-8'))
  end
end
