class UserAuthorize
  attr_reader :telegram_id, :user, :bot, :message

  def initialize(telegram_id, bot, message, site_bot_id)
    @telegram_id = telegram_id
    @bot = bot
    @message = message
    @site_bot_id = site_bot_id
  end

  def perform
    @user = User.find_by(site_bot_id: @site_bot_id, telegram_id: telegram_id)
    return user if user
    @user = User.create(site_bot_id: @site_bot_id, telegram_id: telegram_id, first_name: message.from.first_name)
    Actions::Main.({}, 'current_user' => user, 'message' => message, 'bot' => bot)
    @user
  end
end
