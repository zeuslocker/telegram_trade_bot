class Macro
  extend DefaultMessage

  def self.ParseModelParams(constant:)
    step = ->(_input, options) do
    begin
      options['params'] = JSON.parse(options['message'].text.gsub(constant, ''))
    rescue StandardError => e
      options['bot'].api.sendMessage(default_message(options['message'], e.message)) && false
    end
    end

    [ step, name: "parse_params_#{constant}" ]
  end

  def self.SendValidationFailureResponce
    step = ->(_input, options) do
      options['bot'].api.sendMessage(default_message(options['message'], options['contract.default'].errors.full_messages.join(', ')))
    end
    [ step, name: "send_validation_failure_responce" ]
  end
end
