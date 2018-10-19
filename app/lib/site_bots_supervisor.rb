class SiteBotsSupervisor
  attr_accessor :site_bots

  def initialize
    @site_bots = SiteBot.all.map do |site_bot|
      {
        id: site_bot.id,
        thread: bot_thread(site_bot)
      }
    end
  end

  def add_bot(site_bot_id)
    site_bot = SiteBot.find(site_bot_id)
    @site_bots << { id: site_bot_id, thread: bot_thread(site_bot) }
  end

  def restart_bot(site_bot_id)
    site_bot_item = @site_bots.detect do |site_bot|
      site_bot[:id] == site_bot_id
    end

    site_bot_item[:thread].terminate
    site_bot_item[:thread] = bot_thread(site_bot)
  end

  def restart_all_bots
    @site_bots.each{|x| x[:thread].terminate }
    @site_bots = SiteBot.all.map do |site_bot|
      {
        id: site_bot.id,
        thread: bot_thread(site_bot)
      }
    end
  end

  def terminate_all_bots
    @site_bots.each{|x| x[:thread].terminate }
  end

  def bot_thread(site_bot)
    Thread.new do
      Rails.application.executor.wrap do
        BotThread.new(site_bot).start
      end
    end
  end

  @@instance = SiteBotsSupervisor.new

  def self.instance
    return @@instance
  end

  private_class_method :new
end
