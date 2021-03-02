require 'grape-swagger'
require 'doorkeeper/grape/helpers'

module Api
  class Root < Grape::API 

    helpers Doorkeeper::Grape::Helpers
    helpers(
      ::Helpers::AuthenticateUser
    )

    mount Api::V1::Base
    
    add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: false,
      mount_path: '/api/v1/swagger_doc',
      hide_format: true
    )
  end
end
