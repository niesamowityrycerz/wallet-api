class RegistrationsController < Devise::RegistrationsController

  skip_before_action :doorkeeper_authorize!
  respond_to :json

  def create
    # using default sign_up_params method(from devise)
    # build_resource(sign_in_params) gives {} 
    # that's why I had to overwrite this method
    build_resource(sign_up_params)
    resource.save
    respond_with_resource(resource)
  end

  def sign_up_params
    params.require(:registration).permit(:email, :password, :password_confirmation, :username)
  end





end