require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApiTest
  class Application < Rails::Application
    config.time_zone = 'Europe/Rome'

    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper      = false
    ActiveSupport::JSON::Encoding.time_precision = 0
  end
end
