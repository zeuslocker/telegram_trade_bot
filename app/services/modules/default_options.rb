module Modules
  module DefaultOptions
    def default_options
      {
        'bot' => bot,
        'current_user' => user,
        'message' => message
      }
    end
  end
end
