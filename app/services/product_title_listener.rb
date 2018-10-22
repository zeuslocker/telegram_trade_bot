class ProductTitleListener
  include Modules::DefaultOptions

  attr_reader :bot, :message, :user, :site_bot

  def initialize(bot, message, user, site_bot)
    @bot = bot
    @message = message
    @user = user
    @site_bot = site_bot
  end

  def perform
    Actions::ProductLocations.call(nil, default_options, 'product' => product) if product
  end

  def product
    @product ||= Product.find_by(title: message.text, site_bot_id: site_bot.id)
  end
end
