class SiteBotPolicy < ApplicationPolicy
  def create?
    # should be without site_bot to create
    user.site_bot.blank?
  end
end
