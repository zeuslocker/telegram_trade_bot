module Actions
  class Main < Trailblazer::Operation
    include ::DefaultMessage
    success TrailblazerHelpers::Operations::ResetUserChooses
    step :setup_keyboard!
    step :setup_allowed_messages!
    step :send_responce!

    def reset_user_chooses!(_options, current_user:, **)
      current_user.update(choosen_product_id: nil,
                          choosen_location: nil,
                          choosen_treasure_id: nil,
                          approval_date: nil)
    end

    def send_responce!(_options, bot:, message:, current_user:, key_board:, **)
      bot.api.sendMessage(default_message(message, I18n.t('main', user_data(current_user)), key_board.perform))
    end

    def user_data(current_user)
      {
        client_id: current_user.id,
        balance: current_user.balance,
        total_order_price: current_user.total_order_price
      }
    end

    def setup_keyboard!(options, **)
      options['key_board'] = KeyboardMarkups::Entry.new
    end

    def setup_allowed_messages!(_options, current_user:, key_board:, **)
      current_user.update(allowed_messages: key_board.buttons.flatten)
    end
  end
end
