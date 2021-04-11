class RegistrationsController < Devise::RegistrationsController

  skip_before_action :doorkeeper_authorize!
  respond_to :json

  def create 
    build_resource(sign_up_params)
    # build_resource(sign_in_params) gives {} 
    resource.save
    respond_with_resource(resource)
  end

  # nie działa
  def sign_up_params
    devise_parameter_sanitizer.permit(:sign_up)
  end





end