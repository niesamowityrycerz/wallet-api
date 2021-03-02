class RegistrationsController < Devise::RegistrationsController

  skip_before_action :doorkeeper_authorize!
  before_action :configure_permitted_parameters, if: :devise_controller? 
  respond_to :json

  def create 
    parameters = {"email": "test5@wp.pl", "password": "password@1", "password_confirmation": "password@1"}
    build_resource(sign_up_params)
    # build_resource(sign_in_params) gives {} 
    resource.save
    respond_with_resource(resource)
  end

  # nie działa
  def sign_up_params
    byebug
    params = devise_parameter_sanitizer.permit(:sign_up)
    params
  end

  # protected metods can be called with an explicit receiver, but only when the explicit receiver equals self
  protected 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end





end