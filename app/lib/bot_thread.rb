require 'telegram/bot'

class BotThread
  def initialize(site_bot)
    @site_bot = site_bot
  end

  def start
    ::Telegram::Bot::Client.run(@site_bot.tg_token) do |bot|
      bot.listen do |message|
        begin
          user = UserAuthorize.new(message.from.id, bot, message, @site_bot.id).perform
          MainListener.new(bot, message, user, @site_bot).perform
        rescue Exception => e
          BotLogger.logger.error "Error site_bot.id: #{@site_bot.id}"
          BotLogger.logger.error e.message
          BotLogger.logger.error e.backtrace.join("\n")
          bot.api.sendMessage(chat_id: message.chat.id, text: e.message)
        end
      end
    end
  rescue => e
    BotLogger.logger.error "Error site_bot.id: #{@site_bot.id}"
    BotLogger.logger.error e.message
    retry
  end
end
