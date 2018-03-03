class UserAuthorize
  attr_reader :telegram_id, :user, :bot, :message

  def initialize(telegram_id, bot, message)
    @telegram_id = telegram_id
    @bot = bot
    @message = message
  end

  def perform
    @user = User.find_by(telegram_id: telegram_id)
    return user if user && user.first_name
    return user.update(first_name: message.from.first_name) && user if user
    @user = User.create(telegram_id: telegram_id, first_name: message.from.first_name)
    Actions::Main.({}, 'current_user' => user, 'message' => message, 'bot' => bot)
    @user
  end
end
