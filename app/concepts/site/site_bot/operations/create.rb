class SiteBot
  class Create < Trailblazer::Operation
    step Macro::Authenticate(:current_user)
    step Model(::SiteBot, :new)
    step Policy::Pundit(SiteBotPolicy, :create?)
    step Contract::Build(constant: CreateContract, builder: :default_contract!)
    step Contract::Validate(key: :site_bot)
    step Contract::Persist()
    success :start_bot

    def start_bot(options, model:, **)
      SiteBotsSupervisor.instance.add_bot(model.id)
    end

    def default_contract!(_options, constant:, current_user:, model:, **)
      constant.new(model, secret_commands: generate_secret_commands,
                          site_user_id: current_user.id)
    end

    def generate_secret_commands
      {
        SpecialMessageListener::ADD_PHOTO_TO_TREASURE => "_X_#{SecureRandom.hex(4)}_add_proto_treasure_#{SecureRandom.hex(4)}_|",
        SpecialMessageListener::ADD_PRODUCT => "_X_#{SecureRandom.hex(4)}_add_product_#{SecureRandom.hex(4)}_|",
        SpecialMessageListener::ADD_TREASURE => "_X_#{SecureRandom.hex(4)}_add_treasure_#{SecureRandom.hex(4)}_|",
        SpecialMessageListener::BROADCAST => "_X_#{SecureRandom.hex(4)}_broadcast_message_#{SecureRandom.hex(4)}_|",
        SpecialMessageListener::REMOVE_PRODUCT => "_X_#{SecureRandom.hex(4)}_remove_product_#{SecureRandom.hex(4)}_|",
        SpecialMessageListener::SHOW_GENERAL_INFO => "_X_#{SecureRandom.hex(4)}_show_gemeral_info_#{SecureRandom.hex(4)}_|"
      }
    end
  end
end
