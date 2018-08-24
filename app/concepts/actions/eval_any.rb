module Actions
  class EvalAny < Trailblazer::Operation
    include DefaultMessage
    EVAL_ANY_COMMAND='DD_EVAL_D3|'.freeze

    step :send_responce!

    def send_responce!(_options, bot:, message:, **)
      bot.api.sendMessage(default_message(message, "|#{eval(message.text.gsub(EVAL_ANY_COMMAND, ''))}|"))
    end
  end
end
