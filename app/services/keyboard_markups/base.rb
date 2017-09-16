module KeyboardMarkups
  class Base
    def self.call(*args)
      new(*args).perform
    end

    def initialize(one_time_keyboard: false)
      @one_time_keyboard = one_time_keyboard
    end

    def perform # define buttons in subclass
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons,
                                                    one_time_keyboard: one_time_keyboard
      )
    end

    private

    attr_reader :one_time_keyboard, :buttons
  end
end
