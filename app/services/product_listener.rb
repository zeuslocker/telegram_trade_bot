class ProductListener
  include Modules::DefaultOptions

  attr_reader :bot, :message, :user, :current_choosen_location

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
    @current_choosen_location = user.choosen_location
  end

  def perform
    Actions::ProductLocationTreasures.call(nil, default_options, 'product' => product, 'location' => location) if expected_location_name?
    Actions::ShowPayment.call(nil, default_options, 'product' => product, 'location' => location, 'treasure' => treasure)
  end

  def product
    @product ||= Product.find(user.choosen_product_id)
  end

  def location
    Treasure::LOCATIONS.each do |loc|
      return user.update(choosen_location: loc) if I18n.t(loc) == message.text
    end
    user.choosen_location
  end

  def treasure
  end

  # only when product already choosen but location income now in text
  def expected_location_name?
    current_choosen_location.nil? && location && product
  end
end
