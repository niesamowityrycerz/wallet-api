module Api
  module V1 
    module Groups 
      class Base < Api::V1::Base 
        resource :group do 
          mount Api::V1::Groups::Register
          route_param :group_uid do 
            mount Api::V1::Groups::AcceptInvitation
            mount Api::V1::Groups::RejectInvitation
            mount Api::V1::Groups::IssueDebt
            mount Api::V1::Groups::AddGroupTerms
            mount Api::V1::Groups::Index
          end 
        end

        resource :groups do 
          mount Api::V1::Groups::Overview
        end
      end
    end
  end
end