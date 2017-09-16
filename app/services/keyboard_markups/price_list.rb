module KeyboardMarkups
  class PriceList < Base
    PRODUCT_PER_ROW = 2

    def initialize(one_time_keyboard: true)
      super
      @buttons = []
      Product.pluck(:title).each_slice(PRODUCT_PER_ROW) do |row_names|
        buttons << row_names
      end
      @buttons << [MainListener::MAIN_PAGE]
    end
  end
end
