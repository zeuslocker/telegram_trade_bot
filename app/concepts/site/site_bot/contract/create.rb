class SiteBot
  class CreateContract < Reform::Form
    property :secret_commands
    property :site_user_id
    property :total_income
    property :easy_number
    property :easy_password
    property :tg_token

    validates :secret_commands, presence: true
    validates :site_user_id, presence: true
    validates :easy_number,
              length: { is: 12 },
              presence: true
    validates :easy_password, presence: true
    validates :tg_token, presence: true

    validate :easy_number_format

    def easy_number_format
      /^\d+$/.match(easy_number) && easy_number&.start_with?('380')
    end
  end
end
