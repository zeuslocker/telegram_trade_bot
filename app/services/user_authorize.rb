class UserAuthorize
  attr_reader :telegram_id, :user, :bot, :message

  def initialize(telegram_id, bot, message)
    @telegram_id = telegram_id
    @bot = bot
    @message = message
  end

  def perform
    @user = User.find_by(telegram_id: telegram_id)
    return user if user
    @user = User.create(telegram_id: telegram_id, chat_id: message.chat.id)
    Actions::Main.({}, 'current_user' => user, 'message' => message, 'bot' => bot)
    @user
  end
end
