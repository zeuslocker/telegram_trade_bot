module Actions
  class Main < Trailblazer::Operation
    include ::DefaultMessage

    step :send_responce!

    def send_responce!(options, bot:, message:, params:, current_user:, **)
      bot.api.sendMessage(default_message(message, I18n.t('main', user_data(current_user))))
    end

    def user_data(current_user)
      {
       client_id: current_user.id,
       balance: current_user.balance,
       total_order_price: current_user.total_order_price
      }
    end
  end
end
