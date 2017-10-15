module Actions
  class AddTreasure < Trailblazer::Operation
    ADD_TREASURE = '_Xadd_treasure_|'.freeze # _Xadd_treasure_|{"product_title": "🍃РОЗСИП", "description": "sxsf44rfferg", "lat": 43.32322, "lng": 32.3434, "amount": 1, "location": "suhiv"}
    include DefaultMessage
    extend ::Trailblazer::Operation::Contract::DSL
    contract Forms::TreasureForm

    step ::Macro::ParseModelParams(constant: ADD_TREASURE), fail_fast: true
    step :setup_product_id
    failure :product_not_found, fail_fast: true
    step ::Trailblazer::Operation::Model(::Treasure, :new)
    step ::Trailblazer::Operation::Contract::Build()
    step ::Trailblazer::Operation::Contract::Validate()
    failure ::Macro::SendValidationFailureResponce()
    step ::Trailblazer::Operation::Contract::Persist()
    step :send_responce

    def setup_product_id(options, params:, **)
      options['params'][:product_id] = Product.find_by(title: params['product_title'])&.id
    end

    def product_not_found(options, bot:, message:, **)
      bot.api.sendMessage(default_message(message, I18n.t('product_by_title_not_found')))
    end

    def send_responce(_options, bot:, model:, message:, **)
      bot.api.sendMessage(default_message(message, "Treasure created #{model.attributes.to_json}"))
    end
  end
end
