module KeyboardMarkups
  class RevertPayment < Base
    def initialize(one_time_keyboard: true, pay_from_balance: false)
      super
      @buttons = [[(MainListener::PAY_FROM_BALANCE if pay_from_balance),
                  MainListener::REVERT_PAYMENT_PAGE].compact]
    end
  end
end
