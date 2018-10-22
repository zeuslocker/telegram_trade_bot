class SiteBot
  class Show < Trailblazer::Operation
    step Macro::Authenticate(:current_user)
    step :setup_model

    def setup_model(options, current_user:, **)
      options['model'] = current_user.site_bot
    end
  end
end
