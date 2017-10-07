class TrailblazerHelpers::Operations::ResetUserChooses
  extend Uber::Callable

  def self.call(_options, current_user:, **)
    current_user.update(choosen_product_id: nil,
                        choosen_location: nil,
                        choosen_treasure_id: nil,
                        approval_date: nil)
  end
end
