class Actions::ProductTreasures < Trailblazer::Operation
  include DefaultMessage

  success :setup_model!
  success :responce_message!
  success :send_responce!
  def setup_model!(options, product:, **)
    options['model'] = product.treasures
  end

  def responce_message!(options, model:, product:, **)
    options['responce_message'] = "#{product.title}\n Львов.\nНайдено <b>#{model.count}кладов</b>"
  end

  def setup_reply_markup(options, model:, product:, **)
    options['reply_markup'] = KeyboardMarkups::Treasures.(product_price: product.price, treasures: model)
  end

  def send_responce!(options, model:, bot:, message:, responce_message:, reply_markup:, **)
    bot.api.sendMessage(default_message(message, responce_message, reply_markup))
  end
end
