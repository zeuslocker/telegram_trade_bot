class ProductListener
  include Modules::DefaultOptions
  TREASURE_MESSAGE_VALUES = /\d+\.\d+|\d/
  attr_reader :bot, :message, :user, :current_choosen_location

  def initialize(bot, message, user)
    @bot = bot
    @message = message
    @user = user
    @current_choosen_location = user.choosen_location
  end

  def perform
    return Actions::ProductLocationTreasures.call(nil, default_options, 'product' => product, 'location' => location) if expected_location_name?
    Actions::ShowPayment.call(nil, default_options, 'product' => product, 'location' => location, 'treasure' => treasure)
  end

  def product
    @product ||= Product.find(user.choosen_product_id)
  end

  def location
    return user.choosen_location if user.choosen_location
    Treasure::LOCATIONS.each do |loc|
      if I18n.t(loc) == message.text
        user.update(choosen_location: loc)
        return user.choosen_location
      end
    end
    user.choosen_location
  end

  def treasure
    @treasure ||= product.treasures.joins(:product).find_by(treasure_message_data)
  end

  def treasure_message_data
    return @treasure_message_data if @treasure_message_data
    values = message.text.scan(TREASURE_MESSAGE_VALUES)
    @treasure_message_data ||= {
      products: { price: values[1].to_f / values[0].to_f },
      id: values[2].to_i, amount: values[0].to_f
    }
  end

  # only when product already choosen but location income now in text
  def expected_location_name?
    current_choosen_location.nil? && location && product
  end
end
