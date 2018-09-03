class SiteBotsController < ApplicationController
  before_action :authenticate_site_user!

  def create
    result = SiteBot::Create.call(params, {'current_user' => current_site_user}.with_indifferent_access)
    if result.success?
      redirect_to site_bot_path(result[:model])
    else
      render html: cell(:site_bot, result[:model]).(:new), layout: true
    end
  end

  def new
    render html: cell(:site_bot, SiteBot.new).(:new), layout: true
  end

  def show
    if current_site_user.site_bot.present?
      render html: cell(:site_bot, current_site_user.site_bot).(:show), layout: true
    else
      redirect_to root_path
    end
  end
end
