class SiteBotsSupervisor
  attr_accessor :site_bots

  def initialize
    SiteBot.all.each do |site_bot|
      BotWorker.perform_async(site_bot.id) unless
        present_in_scheduled_set?('BotWorker', [site_bot.id]) || present_in_busy_set?('BotWorker', [site_bot.id])
    end
  end

  def present_in_scheduled_set?(class_name, args)
    r = ::Sidekiq::ScheduledSet.new

    sceduled_result = r.select do |scheduled|
      scheduled.klass == class_name &&
      scheduled.args == args
    end

    sceduled_result.present?
  end

  def present_in_busy_set?(class_name, args)
    workers = Sidekiq::Workers.new

    workers_result = workers.select do |x|
      x[2]['payload']['class'] == class_name &&
      x[2]['payload']['args'] == args
    end

    workers_result.present?
  end

  def add_bot(site_bot_id)
    BotWorker.perform_async(site_bot_id) unless
      present_in_scheduled_set?('BotWorker', [site_bot_id]) || present_in_busy_set?('BotWorker', [site_bot_id])
  end

  def restart_bot(site_bot_id)

  end

  def restart_all_bots

  end

  def terminate_all_bots

  end

  def bot_thread(site_bot)

  end

  @@instance = SiteBotsSupervisor.new

  def self.instance
    return @@instance
  end

  private_class_method :new
end
