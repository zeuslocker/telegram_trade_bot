module KeyboardMarkups
  class RevertPayment < Base
    def initialize(one_time_keyboard: true)
      super
      @buttons = [[MainListener::REVERT_PAYMENT_PAGE]]
    end
  end
end
