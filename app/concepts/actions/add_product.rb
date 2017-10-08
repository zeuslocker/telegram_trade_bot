module Actions
  class AddProduct < ::Trailblazer::Operation
    ADD_PRODUCT = '_Xadd_product_|'.freeze # _Xadd_product_|{"title": "eee", "price": 2}
    include DefaultMessage
    extend ::Trailblazer::Operation::Contract::DSL
    contract ::Forms::ProductForm

    step ::Macro::ParseModelParams(constant: ADD_PRODUCT), fail_fast: true
    step ::Trailblazer::Operation::Model(::Product, :new)
    step ::Trailblazer::Operation::Contract::Build()
    step ::Trailblazer::Operation::Contract::Validate()
    failure ::Macro::SendValidationFailureResponce()
    step ::Trailblazer::Operation::Contract::Persist()
    step :send_responce

    def send_responce(_options, bot:, model:, message:, **)
      bot.api.sendMessage(default_message(message, "Product created #{model.attributes.to_json}"))
    end
  end
end
