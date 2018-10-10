require 'nokogiri'

class Callables::EasypayPaymentSignIn
  extend Uber::Callable

  def self.call(options, site_bot:, **)
    uri1 = URI.parse("#{PayHelpers::EASYPAY_ROOT_URL}auth/signin")
    request1 = Net::HTTP::Get.new(uri1)
    request1["Accept-Language"] = "en-US,en;q=0.9"
    request1["Upgrade-Insecure-Requests"] = "1"
    request1["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.119 Safari/537.36"
    request1["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    request1["Cache-Control"] = "max-age=0"
    request1["Connection"] = "keep-alive"
    req_options = {
      use_ssl: uri1.scheme == "https",
    }

    response1 = Net::HTTP.start(uri1.hostname, uri1.port, req_options) do |http|
      http.request(request1)
    end
    request_verification_token = CGI::Cookie::parse(response1['Set-Cookie'])['HttpOnly, __RequestVerificationToken'].first
    options['sid'] = CGI::Cookie::parse(response1['Set-Cookie'])['SID'].first
    uri = URI.parse("#{PayHelpers::EASYPAY_ROOT_URL}auth/signin")
    options['request_verification_token_for_form'] = Nokogiri::HTML(response1.body.force_encoding(Encoding::UTF_8)).at('input[@name="__RequestVerificationToken"]')['value']

    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Cookie"] = "SID=#{options['sid']}; __RequestVerificationToken=#{request_verification_token}"
    request["Origin"] = "https://partners.easypay.ua"
    request["Accept-Language"] = "en-US,en;q=0.9"
    request["Upgrade-Insecure-Requests"] = "1"
    request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.119 Safari/537.36"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    request["Cache-Control"] = "max-age=0"
    request["Referer"] = "#{PayHelpers::EASYPAY_ROOT_URL}auth/signin"
    request["Connection"] = "keep-alive"
    request.set_form_data(
      "__RequestVerificationToken" => options['request_verification_token_for_form'],
      "gresponse" => "",
      "login" => site_bot.easy_number,
      "password" => site_bot.easy_password,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    options['cookie'] = response['Set-Cookie']
    {request_verification_token_for_form: options['request_verification_token_for_form'], cookie: options['cookie']}
  end
end
