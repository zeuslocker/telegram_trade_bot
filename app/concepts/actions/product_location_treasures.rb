class Actions::ProductLocationTreasures < Trailblazer::Operation
  include DefaultMessage

  step :setup_model!
  step :setup_keyboard!
  step :responce_message!
  step :setup_allowed_messages!
  step :send_responce!

  def setup_model!(options, product:, location:, **)
    options['model'] = product.treasures.where(location: location)
  end

  def responce_message!(options, model:, product:, location:, **)
    options['responce_message'] = I18n.t('location_choosed', product_title: product.title, location: I18n.t(location), count: model.count)
  end

  def setup_keyboard!(options, model:, product:, **)
    options['key_board'] = KeyboardMarkups::Treasures.new(product_price: product.price, treasures: model)
  end

  def setup_allowed_messages!(_options, current_user:, key_board:, **)
    current_user.update(allowed_messages: key_board.buttons.flatten)
  end

  def send_responce!(_options, bot:, message:, responce_message:, key_board:, **)
    bot.api.sendMessage(default_message(message, responce_message, key_board.perform))
  end
end
