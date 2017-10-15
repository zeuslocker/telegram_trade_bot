class Macro
  extend DefaultMessage

  def self.ParseModelParams(constant:, message_method: :text)
    step = lambda do |_input, options|
      begin
        options['params'] = JSON.parse(options['message'].send(message_method).gsub(constant, ''))
      rescue StandardError => e
        options['bot'].api.sendMessage(default_message(options['message'], e.message)) && false
      end
    end

    [step, name: "parse_params_#{constant}"]
  end

  def self.SendValidationFailureResponce
    step = lambda do |_input, options|
      options['bot'].api.sendMessage(default_message(options['message'], options['contract.default'].errors.full_messages.join(', ')))
    end
    [step, name: 'send_validation_failure_responce']
  end
end
