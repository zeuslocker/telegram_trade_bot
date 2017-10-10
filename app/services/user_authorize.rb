class UserAuthorize
  attr_reader :user_name, :user, :bot, :message

  def initialize(user_name, bot, message)
    @user_name = user_name
    @bot = bot
    @message = message
  end

  def perform
    @user = User.find_by(user_name: user_name)
    return user if user
    @user = User.create(user_name: user_name)
    Actions::Main.({}, {'current_user' => user, 'message' => message, 'bot' => bot})
    @user
  end
end
