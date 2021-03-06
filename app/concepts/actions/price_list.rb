class Actions::PriceList < Trailblazer::Operation
  include DefaultMessage

  step :setup_model!
  step :step_plucked_model!
  step :build_list!
  step :setup_keyboard!
  step :setup_allowed_messages!
  step :send_responce!

  def setup_model!(options, site_bot:, **)
    options['model'] = site_bot.products.joins(:treasures)
                                        .where(treasures: { status: :available })
                                        .distinct
  end

  def step_plucked_model!(options, model:, **)
    options['plucked_model'] = model.pluck(:title, :price, :desc)
  end

  def build_list!(options, plucked_model:, **)
    options['price_list'] = plucked_model.each_with_object('') do |product, result|
      result << product_fragment(product)
    end
    options['price_list'].prepend(I18n.t('price_list_header'))
  end

  def setup_keyboard!(options, model:, **)
    options['key_board'] = KeyboardMarkups::PriceList.new(products: model, one_time_keyboard: true)
  end

  def setup_allowed_messages!(_options, current_user:, key_board:, **)
    current_user.update(allowed_messages: key_board.buttons.flatten)
  end

  def send_responce!(_options, bot:, message:, price_list:, key_board:, **)
    bot.api.sendMessage(default_message(message, price_list, key_board.perform))
  end

  def product_fragment(product)
    "<b>#{product[0]}</b>\n1г - #{product[1]}грн.\n#{product[2]}\n\n"
  end
end
