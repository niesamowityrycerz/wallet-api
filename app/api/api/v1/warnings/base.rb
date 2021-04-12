module Api 
  module V1 
    module Warnings
      class Base < Api::V1::Base 

        resource :warnings do 
          mount Api::V1::Warnings::All 
        end

        resource :warning do 
          mount Api::V1::Warnings::Index 
        end
        
      end
    end
  end
end