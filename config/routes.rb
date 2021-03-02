Rails.application.routes.draw do
  use_doorkeeper do 
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users,
      path_prefix: 'api/v1',
      path: '',
      defaults: { format: :json }, # json format, not a form 
      path_names: { registration: 'register'},
      controllers: { registrations: 'registrations' },
      skip: %i[sessions password] #skips creation of these routes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Api::Root => '/'
  #mount GrapeSwaggerRails::Engine, at: '/documentation'
end
