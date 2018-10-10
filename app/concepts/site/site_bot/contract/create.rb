class SiteBot
  class CreateContract < Reform::Form
    include Reform::Form::ActiveModel
    model :site_bot

    property :secret_commands
    property :site_user_id
    property :total_income
    property :easy_number
    property :easy_password
    property :tg_token
    property :wallet_id

    validates :secret_commands, presence: true
    validates :site_user_id, presence: true
    validates :easy_number,
              length: { is: 12 },
              presence: true
    validates :easy_password, presence: true
    validates :tg_token, presence: true

    validate :easy_number_format
    validate :tg_token_original
    validate :easy_pay_account_access, if: -> { easy_number_and_password_valid }
    validates_uniqueness_of :tg_token

    def tg_token_original
      response = Faraday.get "https://api.telegram.org/bot#{tg_token}/getMe"

      errors.add(:tg_token, I18n.t('forms.site_bot/create_contract.tg_token.invalid')) unless
        JSON.parse(response.body)['ok'] == true
    end

    def easy_number_format
      errors.add(:easy_number, I18n.t('forms.site_bot/create_contract.easy_number.wrong_format')) unless
        easy_number_format_validator(easy_number)
    end

    def easy_pay_account_access
      unless sign_in_result[:cookie].start_with?('AUTH_TOKEN')
        errors.add(:easy_number, I18n.t('forms.site_bot/create_contract.easy_number.without_access'))
        errors.add(:easy_password, I18n.t('forms.site_bot/create_contract.easy_number.without_access'))
      else
        self.wallet_id = wallet_id_result
      end
    end

    def easy_number_and_password_valid
      easy_number_format_validator(easy_number)
    end

    def easy_number_format_validator(easy_number)
      /^\d+$/.match(easy_number) && easy_number&.start_with?('380')
    end

    def sign_in_result
      return @sign_in_result if @sign_in_result

      @sign_in_result = Callables::EasypayPaymentSignIn.call({}, site_bot: site_bot)
    end

    def wallet_id_result
      Callables::EasypayWalletId.call({},
        site_bot: site_bot,
        request_verification_token_for_form: sign_in_result[:request_verification_token_for_form],
        cookie: sign_in_result[:cookie])
    end

    def site_bot
      @site_bot ||= SiteBot.new(easy_number: easy_number, easy_password: easy_password)
    end
  end
end
