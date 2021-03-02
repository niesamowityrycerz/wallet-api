module Api
  module V1
    class Base < Root
      version 'v1', using: :path
      prefix :api
      format :json

      mount Api::V1::Users::Base
    end
  end
end