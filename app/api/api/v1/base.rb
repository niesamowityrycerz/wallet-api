module Api
  module V1
    class Base < Root
      version 'v1', using: :path
      prefix :api
      format :json

      mount Api::V1::Users::Base
      mount Api::V1::Transactions::Base
      mount Api::V1::Warnings::Base
      mount Api::V1::Rankings::Base
    end
  end
end