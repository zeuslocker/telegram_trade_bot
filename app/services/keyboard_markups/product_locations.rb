module KeyboardMarkups
  class ProductLocations < Base
    def initialize(locations:, one_time_keyboard: true)
      super
      @buttons = []
      locations.each_slice(2) do |x, y|
        @buttons << [I18n.t(x)]
        @buttons << I18n.t(y) if y
      end
      @buttons << [MainListener::MAIN_PAGE]
    end
  end
end
