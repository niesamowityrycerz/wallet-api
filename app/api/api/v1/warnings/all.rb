module Api
  module V1 
    module Warnings 
      class All < Base 

        before do
          authenticate_user!
        end

        desc 'Show all warnings'

        get do 
          if current_user.admin 
            warnings = ReadModels::Warnings::DebtWarningProjection.all
          else
            warnings = ReadModels::Warnings::DebtWarningProjection.where('user_id = ?', current_user.id)
          end 
   
          warnings_query = ::WarningsQuery.new(warnings, params[:warning_filters], params[:pagination]).call 
          ::Warnings::AllWarningsSerializer.new(warnings_query).serializable_hash
        end
      end
    end
  end
end