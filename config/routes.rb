require 'sidekiq/web'
# Configure Sidekiq-specific session middleware, required for latest sidekiq version
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  use_doorkeeper do 
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users,
      path_prefix: 'api/v1',
      defaults: { format: :json },
      controllers: { registrations: 'registrations' },
      skip: %i[sessions password] 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Api::Root => '/'
  mount GrapeSwaggerRails::Engine, at: '/documentation' 

  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
    end
  end 
  mount Sidekiq::Web, at: '/sidekiq'
  
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
end
