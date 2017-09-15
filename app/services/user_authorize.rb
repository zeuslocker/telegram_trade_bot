class UserAuthorize
  attr_reader :user_name, :user

  def initialize(user_name)
    @user_name = user_name
  end

  def perform
    @user = User.find_or_create_by(user_name: user_name)
  end
end
