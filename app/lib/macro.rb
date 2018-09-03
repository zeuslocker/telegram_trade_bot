class Macro
  extend DefaultMessage

  def self.Debug
    step = lambda do |_input, options|
      binding.pry if Rails.env.test? || Rails.env.development? # defence from fools :)
      true
    end

    [step, name: "debug"]
  end

  def self.Authenticate(user_key)
    step = lambda do |_input, options|
      options['authenticate.result'] = options[user_key].present?
    end

    [step, name: "authenticate.#{user_key}"]
  end

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
