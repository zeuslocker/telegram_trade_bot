class SpecialMessageListener
  ADD_PRODUCT = '_Xadd_product_|'.freeze

  include DefaultMessage

  attr_reader :bot, :message

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  # def perform
  #   add_product_action if message.text.start_with?('_Xadd_product_|')
  # end
  #
  # private
  #
  # def add_product_action
  #
  #   bot.api.sendMessage(default_message(message, product_json.to_json))
  # end
  #
  # def create_product
  #   add_product_params
  # end

  def add_product_params
    product_json = JSON.parse(message.text.gsub('ADD_PRODUCT', ''))
  rescue StandardError => e
    bot.api.sendMessage(default_message(message, e.message))
  end
end
