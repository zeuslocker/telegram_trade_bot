module Actions
  class AddPhotoToTreasure < Trailblazer::Operation
    ADD_PHOTO_TREASURE = '_Xadd_proto_treasure_|'.freeze # _Xadd_proto_treasure_|{"id": "eee"}
    include DefaultMessage

    step ::Macro::ParseModelParams(constant: ADD_PHOTO_TREASURE, message_method: :caption), fail_fast: true
    step :setup_model
    failure :product_not_found, fail_fast: true
    step :update_treasure
    step :send_responce

    def setup_model(options, params:, **)
      options['model'] = ::Treasure.find_by(id: params['id'])
    end

    def product_not_found(options, bot:, message:, **)
      bot.api.sendMessage(default_message(message, I18n.t('treasure_by_title_not_found')))
    end

    def update_treasure(options, model:, message:, **)
      model.update(file_ids: (model.file_ids | [message&.document&.file_id]).compact)
    end

    def send_responce(_options, bot:, model:, message:, **)
      bot.api.sendMessage(default_message(message, "Treasure photo attached #{model.attributes.to_json}"))
    end
  end
end
