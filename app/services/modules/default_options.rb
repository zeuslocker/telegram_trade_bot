module Modules
  module DefaultOptions
    def default_options
      {
        'bot' => bot,
        'current_user' => user,
        'message' => message,
        'site_bot' => site_bot
      }
    end
  end
end
