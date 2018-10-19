module Actions
  class RemoveProduct < ::Trailblazer::Operation
    # _Xremove_product_|{"title": "eee"}
    include DefaultMessage

    step ::Macro::ParseModelParams(constant: SpecialMessageListener::REMOVE_PRODUCT), fail_fast: true
    step :setup_model!
    failure :model_not_found!
    step :destroy_model!
    step :send_responce!

    def setup_model!(options, params:, site_bot:, **)
      options['model'] = Product.find_by(title: params['title'], site_bot_id: site_bot.id)
    end

    def model_not_found!(_options, bot:, message:, **)
      bot.api.sendMessage(default_message(message, I18n.t('product_by_title_not_found')))
    end

    def destroy_model!(_options, model:, **)
      model.destroy
    end

    def send_responce!(_options, bot:, model:, message:, **)
      bot.api.sendMessage(default_message(message, "Product destroyed #{model.attributes.to_json}"))
    end
  end
end
