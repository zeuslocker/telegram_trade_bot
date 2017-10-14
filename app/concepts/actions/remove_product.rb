module Actions
  class RemoveProduct < ::Trailblazer::Operation
    REMOVE_PRODUCT = '_Xremove_product_|'.freeze # _Xremove_product_|{"title": "eee"}
    include DefaultMessage

    step ::Macro::ParseModelParams(constant: REMOVE_PRODUCT), fail_fast: true
    step :setup_model!
    failure :model_not_found!
    step :destroy_model!
    step :send_responce!

    def setup_model!(options, params:, **)
      options['model'] = Product.find_by(title: params['title'])
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
