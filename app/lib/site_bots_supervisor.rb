class SiteBotsSupervisor
  attr_accessor :site_bots

  def initialize
    SiteBot.all.each do |site_bot|
      bot = BotWorker.new(site_bot.id)
      Celluloid::Actor[site_bot.site_user.username] = bot
      bot.async.perform
    end
  end

  def add_bot(site_bot)
    bot = BotWorker.new(site_bot.id)
    Celluloid::Actor[site_bot.site_user.username] = bot
    bot.async.perform
  end

  def restart_bot(site_bot)
    Celluloid::Actor[site_bot.site_user.username]&.terminate
    site_bot.update(status: :enabled)
    bot = BotWorker.new(site_bot.id)
    Celluloid::Actor[site_bot.site_user.username] = bot
    bot.async.perform
  end

  def restart_all_bots
    SiteBot.all.each do |site_bot|
      restart_bot(site_bot)
    end
  end

  def terminate_bot(site_bot)
    Celluloid::Actor[site_bot.site_user.username]&.terminate
  end

  def terminate_all_bots
    SiteBot.all.each do |site_bot|
      terminate_bot(site_bot)
    end
  end

  @@instance = SiteBotsSupervisor.new

  def self.instance
    return @@instance
  end

  private_class_method :new
end
