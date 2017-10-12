module KeyboardMarkups
  class Entry < Base
    def initialize(one_time_keyboard: false)
      super
      @buttons = [[MainListener::RULES_PAGE, MainListener::PRICE_LIST_PAGE, MainListener::HOW_TO_PAY_PAGE],
                  [MainListener::REPLENISH_BALANCE]]
    end
  end
end
