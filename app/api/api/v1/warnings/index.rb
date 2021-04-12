module Api 
  module V1 
    module Warnings
      class Index < Base 

        #before do 
        #  authenticate_user!
        #end

        desc 'Get warning by uid'

        route_param :warning_uid do 
          get do 
            warning = ReadModels::Warnings::TransactionWarningProjection.find_by!(warning_uid: params[:warning_uid])
            if current_user.admin || current_user.id == warning.user_id
              ::Warnings::WarningSerializer.new(warning).serializable_hash.to_json
            else 
              403 
            end
          end
        end

      end
    end
  end
end