require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper do 
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users,
      path_prefix: 'api/v1',
      defaults: { format: :json },
      controllers: { registrations: 'registrations' },
      skip: %i[sessions password] 
       #skips creation of these routes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Api::Root => '/'
  mount GrapeSwaggerRails::Engine, at: '/documentation'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
  end
  mount Sidekiq::Web, at: '/sidekiq'
  
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
end
