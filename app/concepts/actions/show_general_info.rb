class Actions::ShowGeneralInfo < Trailblazer::Operation
  include DefaultMessage

  GENERAL_INFO_MESSAGE = '_Xshow_gemeral_infoXX3_'.freeze

  success :setup_model!
  success :setup_responce_message!
  success :send_responce!

  def setup_model!(options, **)
    options['model'] = ::User.all
  end

  def setup_responce_message!(options, model:, **)
    options['responce_message'] = "".tap do |result|
      model.each do |user|
        result << "id: #{user.id} tel_id: #{user.telegram_id} balance: #{user.balance}\n"
      end
    end
  end

  def send_responce!(_options, bot:, message:, responce_message:, **)
    bot.api.sendMessage(default_message(message, responce_message))
  end
end
