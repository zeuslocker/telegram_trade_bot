module Actions
  class Main < Trailblazer::Operation
    include ::DefaultMessage
    success :reset_user_chooses!
    step :keyboard_markup!
    step :send_responce!

    def reset_user_chooses!(options, current_user:, **)
      current_user.update(choosen_product_id: nil)
    end

    def send_responce!(_options, bot:, message:, current_user:, keyboard_markup:, **)
      bot.api.sendMessage(default_message(message, I18n.t('main', user_data(current_user))).merge(reply_markup: keyboard_markup))
    end

    def user_data(current_user)
      {
        client_id: current_user.id,
        balance: current_user.balance,
        total_order_price: current_user.total_order_price
      }
    end

    def keyboard_markup!(options, **)
      options['keyboard_markup'] = KeyboardMarkups::Entry.()
    end
  end
end
