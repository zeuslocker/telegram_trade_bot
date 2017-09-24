module Actions
  class ShowPayment < Trailblazer::Operation
    include DefaultMessage
    step :translation_options
    step :responce_message
    step :update_user
    step :send_responce

    def translation_options(options, product:, location:, treasure:, **)
      options['translation_options'] = {
         product_title: product.title,
         pay_price: TreasurePrice.call(product, treasure),
         treasure_id: treasure.id,
         pay_method: 'EasyPay',
         wallet: Wallet.instance.easypay,
         location: I18n.t('pay_location', location: I18n.t(location)[1..-1])
      }
    end

    def responce_message(options, translation_options:, **)
      options['responce_message'] = I18n.t('show_payment', translation_options)
    end

    def update_user(options, current_user:, treasure:, **)
      current_user.update(choosen_treasure_id: treasure.id, approval_date: Time.current)
    end

    def send_responce(_options, bot:, message:, responce_message:, **)
      bot.api.sendMessage(default_message(message, responce_message))
      bot.api.sendMessage(default_message(message, I18n.t('confirmation_code')))
    end
  end
end
