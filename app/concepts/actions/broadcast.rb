class Actions::Broadcast < Trailblazer::Operation
  include DefaultMessage

  BROADCAST_MESSAGE = '_Xbroadcast_message_|'.freeze # _Xbroadcast_message_|{"message": "gg!"}

  step :setup_model!
  step ::Macro::ParseModelParams(constant: BROADCAST_MESSAGE), fail_fast: true
  step :setup_message!
  step :send_broadcast!

  def setup_model!(options, **)
    options['model'] = ::User.all
  end

  def setup_message!(options, params:, **)
    options['text'] = params['message']
  end

  def send_broadcast!(_options, message:, model:, bot:, text:, **)
    model.each do |user|
      bot.api.sendMessage(chat_id: user.telegram_id, text: text)
    end
  end
end
