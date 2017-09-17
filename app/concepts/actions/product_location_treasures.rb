class Actions::ProductLocationTreasures < Trailblazer::Operation
  include DefaultMessage

  step :setup_model!
  step :setup_reply_markup!
  step :responce_message!
  step :send_responce!

  def setup_model!(options, product:, location:, **)
    options['model'] = product.treasures.where(location: location)
  end

  def responce_message!(options, model:, product:, location:, **)
    options['responce_message'] = I18n.t('location_choosed', product_title: product.title, location: I18n.t(location), count: model.count)
  end

  def setup_reply_markup!(options, model:, product:, **)
    options['reply_markup'] = KeyboardMarkups::Treasures.(product_price: product.price, treasures: model)
  end

  def send_responce!(_options, bot:, message:, responce_message:, reply_markup:, **)
    bot.api.sendMessage(default_message(message, responce_message, reply_markup))
  end
end
