module Actions
  class HowToPay < Trailblazer::Operation
    include DefaultMessage

    step :send_responce!

    def send_responce!(options, bot:, message:, **)
      bot.api.sendMessage(default_message(message, I18n.t('how_to_pay_info')))
    end
  end
end
