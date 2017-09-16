module KeyboardMarkups
  class Entry < Base
    def initialize(one_time_keyboard: false)
      super
      @buttons = [[MainListener::RULES_PAGE, MainListener::PRICE_LIST_PAGE]]
    end
  end
end
