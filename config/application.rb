require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'pry'
require 'telegram/bot'
require_relative '../app/modules/default_message'
TELEGRAM_TOKEN = '448462483:AAGYcrVZJDEZyScLYMzIElUzNLNeGLaUbNQ'.freeze

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BotTg
  class Application < Rails::Application
    include DefaultMessage
    config.load_defaults 5.1
    config.generators.system_tests = nil
    config.i18n.default_locale = :ua
    config.after_initialize do
      Telegram::Bot::Client.run(TELEGRAM_TOKEN) do |bot|
        bot.listen do |message|
          begin
            user = UserAuthorize.new(message.from.username, bot, message).perform
            MainListener.new(bot, message, user).perform
          rescue Exception => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
            begin
              bot.api.sendMessage(chat_id: message.chat.id, text: e.message)
            rescue Exception => e
            end
          end
        end
      end
    end
  end
end
