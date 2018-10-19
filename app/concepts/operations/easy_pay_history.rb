class Operations::EasyPayHistory < Trailblazer::Operation
  include DefaultMessage
  step :perform

  def perform(options, bot:, message:, site_bot:, **)
    bot.api.sendMessage(default_message(message, I18n.t('payment_checking')))

    response = history_request(site_bot.last_request_verification_token_for_form,
                               site_bot.last_cookie,
                               site_bot.easy_number,
                               site_bot.easy_password,
                               site_bot.wallet_id)
    if(response.code.to_i == 200)
      options['pay_history_page'] = Nokogiri::HTML(response.body.force_encoding('UTF-8'))
    else
      credentials = sign_in_request(site_bot.easy_number, site_bot.easy_password)
      response = history_request(credentials[:request_verification_token_for_form],
                                 credentials[:cookie],
                                 site_bot.easy_number,
                                 site_bot.easy_password,
                                 site_bot.wallet_id)
      options['pay_history_page'] = Nokogiri::HTML(response.body.force_encoding('UTF-8'))

      site_bot.update(
        last_cookie: credentials[:cookie],
        last_request_verification_token_for_form: credentials[:request_verification_token_for_form]
      )
    end
  end

  def sign_in_request(easy_number, easy_password)
    uri1 = URI.parse("#{PayHelpers::EASYPAY_ROOT_URL}auth/signin")
    request1 = Net::HTTP::Get.new(uri1)
    request1["Accept-Language"] = "en-US,en;q=0.9"
    request1["Upgrade-Insecure-Requests"] = "1"
    request1["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.119 Safari/537.36"
    request1["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    request1["Cache-Control"] = "max-age=0"
    request1["Connection"] = "keep-alive"
    req_options = {
      use_ssl: uri1.scheme == "https"
    }

    response1 = Net::HTTP.start(uri1.hostname, uri1.port, req_options) do |http|
      http.request(request1)
    end
    request_verification_token = CGI::Cookie::parse(response1['Set-Cookie'])['HttpOnly, __RequestVerificationToken'].first
    sid = CGI::Cookie::parse(response1['Set-Cookie'])['SID'].first
    uri = URI.parse("#{PayHelpers::EASYPAY_ROOT_URL}auth/signin")
    request_verification_token_for_form = Nokogiri::HTML(response1.body.force_encoding(Encoding::UTF_8)).at('input[@name="__RequestVerificationToken"]')['value']

    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Cookie"] = "SID=#{sid}; __RequestVerificationToken=#{request_verification_token}"
    request["Origin"] = PayHelpers::EASYPAY_ROOT_URL[0..-2]
    request["Accept-Language"] = "en-US,en;q=0.9"
    request["Upgrade-Insecure-Requests"] = "1"
    request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.119 Safari/537.36"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    request["Cache-Control"] = "max-age=0"
    request["Referer"] = "#{PayHelpers::EASYPAY_ROOT_URL}auth/signin"
    request["Connection"] = "keep-alive"
    request.set_form_data(
      "__RequestVerificationToken" => request_verification_token_for_form,
      "gresponse" => "",
      "login" => easy_number,
      "password" => easy_password,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    {cookie: response['Set-Cookie'], request_verification_token_for_form: request_verification_token_for_form}
  end

  def history_request(request_verification_token_for_form, cookie, easy_number, easy_password, easy_wallet_id)
    time_current = Time.current
    uri = URI.parse("#{PayHelpers::EASYPAY_ROOT_URL}wallets/buildreport?walletId=#{easy_wallet_id}&month=#{time_current.month}&year=#{time_current.year}")
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/x-www-form-urlencoded'
    request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    request['Accept-Language'] = 'en-US,en;q=0.5'
    request['Cache-Control'] = 'no-cache'
    request['Connection'] = 'keep-alive'
    request['Cookie'] = cookie
    request['Host'] = 'partners.easypay.ua'
    request['Referer'] = PayHelpers::EASYPAY_ROOT_URL
    request['Upgrade-Insecure-Requests'] = '1'
    request['User-Agent'] = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0'
    request.set_form_data(
      '__RequestVerificationToken' => request_verification_token_for_form,
      'login' => easy_number,
      'password' => easy_password
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end
end
