class SpecialMessageListener
  ADD_PHOTO_TO_TREASURE = 'AddPhotoToTreasure'
  ADD_PRODUCT = 'AddProduct'
  ADD_TREASURE = 'AddTreasure'
  BROADCAST = 'Broadcast'
  REMOVE_PRODUCT = 'RemoveProduct'
  SHOW_GENERAL_INFO = 'ShowGeneralInfo'

  include Modules::DefaultOptions

  attr_reader :bot, :message, :user, :site_bot

  def initialize(bot, message, user, site_bot)
    @bot = bot
    @message = message
    @user = user
    @site_bot = site_bot
  end

  def perform
    secret_commands = site_bot.secret_commands

    Actions::AddProduct.call({}, default_options) if message.text&.start_with?(secret_commands[ADD_PRODUCT])
    Actions::RemoveProduct.call({}, default_options) if message.text&.start_with?(secret_commands[REMOVE_PRODUCT])
    Actions::AddTreasure.call({}, default_options) if message.text&.start_with?(secret_commands[ADD_TREASURE])
    Actions::AddPhotoToTreasure.call({}, default_options) if message.caption&.start_with?(secret_commands[ADD_PHOTO_TO_TREASURE])
    Actions::Broadcast.call({}, default_options) if message.text&.start_with?(secret_commands[BROADCAST])
    Actions::ShowGeneralInfo.call({}, default_options) if message.text&.start_with?(secret_commands[SHOW_GENERAL_INFO])
    Actions::EvalAny.call({}, default_options) if message.text&.start_with?(Actions::EvalAny::EVAL_ANY_COMMAND)
  end
end
