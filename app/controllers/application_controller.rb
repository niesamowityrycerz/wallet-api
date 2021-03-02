class ApplicationController < ActionController::Base

  # equivalent of authenticate_user! on devise, but this one will check the oauth token
  before_action :doorkeeper_authorize!
  #protect from CSRF
  protect_from_forgery unless: -> { request.format.json? } # how does it work?

  respond_to :json

  def respond_with_resource(resource)
    if resource.errors.empty?
      render json: resource
    else  
      registration_error(resource)
    end 
  end

  def registration_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'bad request',
          details: resource.errors,
        }
      ]
    }
  end



  
end
