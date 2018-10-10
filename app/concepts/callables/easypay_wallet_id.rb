require 'nokogiri'

class Callables::EasypayWalletId
  extend Uber::Callable

  def self.call(options, site_bot:, request_verification_token_for_form:, cookie:, **)
    time_current = Time.current
    uri = URI.parse("#{PayHelpers::EASYPAY_ROOT_URL}home")
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
      'login' => site_bot.easy_number,
      'password' => site_bot.easy_password
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    options['wallet_id'] = Nokogiri::HTML(response.body.force_encoding('UTF-8')).at('ul.popup-menu > :first-child a')['href'][/([^\/]+)$/]
  end
end
