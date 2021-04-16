module Api
  module V1 
    module Warnings 
      class All < Base 

        before do
          authenticate_user!
        end

        desc 'Show all warnings'

        get do 
          warnings = ReadModels::Warnings::TransactionWarningProjection.all
          if current_user.admin 
            warnings
          elsif warnings.user_id == current_user.id
            warnings.where('user_id = ?', current_user.id)
          else  
            403 
          end 
   
          w = ::WarningsQuery.new(warnings, params[:warning_filters], params[:pagination]).call 
          ::Warnings::AllWarningsSerializer.new(w).serializable_hash
        end
      end
    end
  end
end