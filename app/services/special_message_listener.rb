class SpecialMessageListener
  include Modules::DefaultOptions

  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform
    Actions::AddProduct.call({}, default_options) if message.text.start_with?(Actions::AddProduct::ADD_PRODUCT)
    Actions::AddTreasure.call({}, default_options) if message.text.start_with?(Actions::AddTreasure::ADD_TREASURE)
  end
end
