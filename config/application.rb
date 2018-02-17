require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StravaApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    if Rails.env.test?
      config.autoload_paths += %w(lib lib/**)
    else
      config.eager_load_paths += Dir["#{config.root}/lib/**/"].select { |f| File.directory?(f) }
    end

    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags = [:subdomain, :uuid]
    config.logger = ActiveSupport::TaggedLogging.new(logger)

    # setting cache_store in here will be overriden by env.rb
    # REDIS_CONFIG = YAML.load(File.open( Rails.root.join("config/redis.yml") ) ).deep_symbolize_keys[Rails.env.to_sym]
    # config.cache_store = :redis_store, REDIS_CONFIG
  end
end
