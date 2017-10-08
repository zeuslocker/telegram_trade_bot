class Actions::ProductLocations < Trailblazer::Operation
  include DefaultMessage

  step :setup_choosen_product!
  step :available_locations!
  step :setup_keyboard!
  step :setup_allowed_messages!
  step :send_responce!

  def setup_choosen_product!(_options, current_user:, product:, **)
    current_user.update(choosen_product_id: product.id)
  end

  def available_locations!(options, product:, **)
    options['available_locations'] = product.treasures.where(status: :available).pluck(:location).uniq
  end

  def setup_keyboard!(options, available_locations:, **)
    options['key_board'] = KeyboardMarkups::ProductLocations.new(locations: available_locations)
  end

  def setup_allowed_messages!(_options, current_user:, key_board:, **)
    current_user.update(allowed_messages: key_board.buttons.flatten)
  end

  def send_responce!(_options, bot:, message:, product:, key_board:, **)
    bot.api.sendMessage(default_message(message, product.title.to_s, key_board.perform))
  end
end
