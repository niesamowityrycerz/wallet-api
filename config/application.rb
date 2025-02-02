require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WalletApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('domains',   'debts', 'lib')
    config.eager_load_paths << Rails.root.join('domains',   'ranking_points', 'lib')
    config.eager_load_paths << Rails.root.join('domains',   'warnings', 'lib')
    config.eager_load_paths << Rails.root.join('domains',   'groups', 'lib')
    config.eager_load_paths << Rails.root.join('domains',   'processes')

    #config.eager_load_paths << Rails.root.join('queries')
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')

    # add to autoloadpath every file within app/api
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.

    # configure rails to use sidekiq as a background processes manager(intead of ActiveJob)
    config.active_job.queue_adapter = :sidekiq
    
    config.api_only = true
  end
end
