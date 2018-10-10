class BotLogger
  def self.log(msg)
    logger.info(msg)
  end

  def self.logger
    @@logger ||= Logger.new("#{Rails.root}/log/bots.log")
  end
end
