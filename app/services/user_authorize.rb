class UserAuthorize
  attr_reader :user_name, :user

  def initialize(user_name)
    @user_name = user_name
  end

  def perform
    @user = User.find_by(user_name: user_name) || User.create(user_name: user_name, allowed_messages: default_allowed_messages)
  end

  def default_allowed_messages
    [MainListener::MAIN_PAGE, MainListener::RULES_PAGE, MainListener::PRICE_LIST_PAGE]
  end
end
