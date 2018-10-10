class SiteBot
  class Show < Trailblazer::Operation
    step Macro::Authenticate(:current_user)
    step :setup_model
    success :update_model_status

    def setup_model(options, current_user:, **)
      options['model'] = current_user.site_bot
    end

    def update_model_status(options, model:, **)
      bot_thread = SiteBotsSupervisor.instance.site_bots.find{|x| x[:id] == model.id}[:thread]
      status = bot_thread.status
      if status == 'sleep' || status == 'run'
        model.update(status: :enabled)
      else
        model.update(status: :disabled)
      end
    end
  end
end
