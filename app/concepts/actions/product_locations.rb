class Actions::ProductLocations < Trailblazer::Operation
  include DefaultMessage

  step :setup_choosen_product!
  step :available_locations!
  step :send_responce!

  def setup_choosen_product!(_options, current_user:, product:, **)
    current_user.update(choosen_product_id: product.id)
  end

  def available_locations!(options, product:, **)
    options['available_locations'] = product.treasures.pluck(:location).uniq
  end

  def send_responce!(_options, bot:, message:, product:, available_locations:, **)
    bot.api.sendMessage(default_message(message, "#{product.title}", KeyboardMarkups::ProductLocations.(locations: available_locations)))
  end
end
