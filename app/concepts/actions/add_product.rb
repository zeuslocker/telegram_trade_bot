module Actions
  class AddProduct < ::Trailblazer::Operation
    # _Xadd_product_|{"title": "eee", "price": 2}
    include DefaultMessage

    step ::Macro::ParseModelParams(constant: SpecialMessageListener::ADD_PRODUCT), fail_fast: true
    step ::Trailblazer::Operation::Model(::Product, :new)
    step ::Trailblazer::Operation::Contract::Build(constant: ::Forms::ProductForm, builder: :default_contract!)
    step ::Trailblazer::Operation::Contract::Validate()
    failure ::Macro::SendValidationFailureResponce()
    step ::Trailblazer::Operation::Contract::Persist()
    step :send_responce

    def default_contract!(_options, constant:, site_bot:, model:, **)
      constant.new(model, site_bot_id: site_bot.id)
    end

    def send_responce(_options, bot:, model:, message:, **)
      bot.api.sendMessage(default_message(message, "Product created #{model.attributes.to_json}"))
    end
  end
end
