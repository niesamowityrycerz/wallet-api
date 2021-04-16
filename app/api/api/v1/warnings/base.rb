module Api 
  module V1 
    module Warnings
      module WarningFilters
        extend Grape::API::Helpers 

        params :warning_filters do 
          optional :username, type: String, values: ::User.all.username 
          optional :warning_type, type: String, values: ::WarningType.all.name 
          optional :sent_at, type: Hash do 
            optional :from, type: Date
            optional :to, type: Date 
            all_or_none_of :from, :to 
          end
          optional :penalty_points, type: Hash do 
            optional :min, type: Float 
            optional :max, type: Float 
            all_or_none_of :min, :max
          end
        end

      end
      class Base < Api::V1::Base 

        helpers(
          WarningFilters
        )
        
        resource :warnings do 
          mount Api::V1::Warnings::All 
        end
        
      end
    end
  end
end