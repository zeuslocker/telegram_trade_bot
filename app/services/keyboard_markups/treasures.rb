class KeyboardMarkups::Treasures < KeyboardMarkups::Base
  def initialize(product_price:, treasures:, one_time_keyboard: true)
    super
    @buttons = []
    treasures.each_slice(2) do |x, y|
      result = [I18n.t('treasure.title', amount: x.amount, price: product_price * x.amount, id: x.id)]
      result << I18n.t('treasure.title', amount: y.amount, price: product_price * y.amount, id: y.id) if y
      @buttons << result
    end
    @buttons << MainListener::MAIN_PAGE
  end
end
