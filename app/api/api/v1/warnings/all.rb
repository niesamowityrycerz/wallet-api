module Api
  module V1 
    module Warnings 
      class All < Base 

        #before do
        #  authenticate_user!
        #end

        desc 'Show all warnings'

        get do 
          if current_user.admin 
            warnings = ReadModels::Warnings::TransactionWarningProjection.all
            ::Warnings::AllWarningsSerializer.new(warnings).serializable_hash.to_json
          else  
            403 
          end
        end
        
      end
    end
  end
end