class Actions::PriceList < Trailblazer::Operation
  include DefaultMessage

  step :setup_model!
  step :step_plucked_model!
  step :build_list!
  step :send_responce!

  def setup_model!(options, **)
    options['model'] = ::Product.joins(:treasures).distinct
  end

  def step_plucked_model!(options, model:, **)
    options['plucked_model'] = model.pluck(:title, :price)
  end

  def build_list!(options, plucked_model:, **)
    options['price_list'] = plucked_model.each_with_object('') do |product, result|
      result << product_fragment(product)
    end
    options['price_list'].prepend(I18n.t('price_list_header'))
  end

  def send_responce!(_options, bot:, model:, message:, price_list:, **)
    bot.api.sendMessage(default_message(message, price_list, KeyboardMarkups::PriceList.(products: model, one_time_keyboard: true)))
  end

  def product_fragment(product)
    "<b>#{product[0]}</b>\n  1г - #{product[1]}грн.\n"
  end
end
