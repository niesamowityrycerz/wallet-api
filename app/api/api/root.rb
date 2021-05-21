require 'grape-swagger'
require 'doorkeeper/grape/helpers'

module Api
  class Root < Grape::API 
    # rescue all StandardError(including those I have defined)
    include Api::Errors
   

    helpers Doorkeeper::Grape::Helpers
    helpers(
      ::Helpers::AuthenticateUser,
      ::Helpers::Pagination
    )

    mount Api::V1::Base

    route :any, '*path' do 
      error!('We cannot find this!', 404)
    end
    
    add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: false,
      mount_path: '/api/v1/swagger_doc',
      hide_format: true
    )
  end
end
