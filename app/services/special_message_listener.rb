class SpecialMessageListener
  include Modules::DefaultOptions

  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform
    Actions::AddProduct.call({}, default_options) if message.text&.start_with?(Actions::AddProduct::ADD_PRODUCT)
    Actions::RemoveProduct.call({}, default_options) if message.text&.start_with?(Actions::RemoveProduct::REMOVE_PRODUCT)
    Actions::AddTreasure.call({}, default_options) if message.text&.start_with?(Actions::AddTreasure::ADD_TREASURE)
    Actions::AddPhotoToTreasure.call({}, default_options) if message.caption&.start_with?(Actions::AddPhotoToTreasure::ADD_PHOTO_TREASURE)
  end
end
