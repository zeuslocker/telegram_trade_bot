module Actions
  class AddProduct < ::Trailblazer::Operation
    ADD_PRODUCT = '_Xadd_product_|'.freeze
    include DefaultMessage
    extend ::Trailblazer::Operation::Contract::DSL

    contract ::Forms::ProductForm
    step :params_parse
    step ::Trailblazer::Operation::Model(::Product, :new)
    step ::Trailblazer::Operation::Contract::Build()
    step ::Trailblazer::Operation::Contract::Validate()
    failure :send_validation_failure_responce
    step ::Trailblazer::Operation::Contract::Persist()
    step :send_responce

    def params_parse(options, message:, bot:, **)
      options['params'] = JSON.parse(message.text.gsub(ADD_PRODUCT, ''))
    rescue StandardError => e
      bot.api.sendMessage(default_message(message, e.message)) && false
    end

    def send_validation_failure_responce(options, bot:, message:, **)
      bot.api.sendMessage(default_message(message, options['contract.default'].errors.full_messages.join(', ')))
    end

    def send_responce(_options, bot:, model:, message:, **)
      bot.api.sendMessage(default_message(message, "Product created #{model.attributes.to_json}"))
    end
  end
end
