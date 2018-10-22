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
require 'sidekiq/api'
require "celluloid/autostart"
require 'telegram/bot'
require_relative '../app/modules/default_message'


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
      SiteBotsSupervisor.instance
    end
  end
end
