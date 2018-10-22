class BotWorker
  include Celluloid

  def initialize(site_bot_id)
    @site_bot_id = site_bot_id
  end

  def perform
    site_bot = SiteBot.find(@site_bot_id)
    ::Telegram::Bot::Client.run(site_bot.tg_token) do |bot|
      bot.listen do |message|
        # send this message to bot before call SiteBotsSupervisor.instance.restart_bot/terminate_bot
        break if site_bot.reload.status == 'disabled'
        begin
          user = UserAuthorize.new(message.from.id, bot, message, site_bot.id).perform
          MainListener.new(bot, message, user, site_bot).perform
        rescue Exception => e
          BotLogger.logger.error "Error site_bot.id: #{site_bot.id}"
          BotLogger.logger.error e.message
          BotLogger.logger.error e.backtrace.join("\n")
          bot.api.sendMessage(chat_id: message.chat.id, text: e.message)
        end
      end
    end
  rescue => e
    site_bot = SiteBot.find(@site_bot_id)
    BotLogger.logger.error "Error site_bot.id: #{site_bot.id}"
    BotLogger.logger.error e.message
    retry
  end
end
