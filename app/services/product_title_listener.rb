class ProductTitleListener
  include Modules::DefaultOptions

  attr_reader :bot, :message, :user

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
  end

  def perform
    Actions::ProductLocations.call(nil, default_options, 'product' => product) if product
  end

  def product
    @product ||= Product.find_by(title: message.text)
  end
end
