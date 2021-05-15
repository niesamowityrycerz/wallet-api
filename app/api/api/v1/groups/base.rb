module Api
  module V1 
    module Groups 
      class Base < Api::V1::Base 
        resource :group do 
          mount Api::V1::Groups::Register
          route_param :group_uid, type: String do 
            mount Api::V1::Groups::AcceptInvitation
            mount Api::V1::Groups::RejectInvitation
            mount Api::V1::Groups::IssueDebt
            mount Api::V1::Groups::AddGroupTerms
            mount Api::V1::Groups::Index
            mount Api::V1::Groups::Leave
            mount Api::V1::Groups::Close
          end 
        end

        resource :groups do 
          mount Api::V1::Groups::Overview
          mount Api::V1::Groups::Invitations
        end
      end
    end
  end
end