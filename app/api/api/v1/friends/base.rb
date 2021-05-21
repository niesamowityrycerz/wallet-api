module Api 
  module V1 
    module Friends 
      module FriendshipsErrors
        extend Grape::API::Helpers 

        def friendship_errors
          requested_user = User.find_by!(id: params[:user_id])
          if requested_user.blocked_friends.include? current_user
            error!('user blocked you', 404)
          elsif (current_user.pending_friends.include? requested_user) && (self.env["REQUEST_URI"].split('/')[-1] == 'add')
            error!('you have already send a request', 404)
          elsif (!current_user.friends.include? requested_user) && (self.env["REQUEST_URI"].split('/')[-1] == 'delete')
            error!('You cannot remove friend from unexisiting friendship', 404)
          elsif (current_user.friends.include? requested_user) && (self.env["REQUEST_URI"].split('/')[-1] == 'add')
            error!('You are already friends!', 404)
          else
            false 
          end
        end

      end

      class Base < Api::V1::Base 

        helpers(
          FriendshipsErrors
        )

        resource :friends do 
          mount Api::V1::Friends::Add
        end 

        resource :friend do 
          route_param :user_id do 
            mount Api::V1::Friends::Accept
            mount Api::V1::Friends::Delete
            mount Api::V1::Friends::Reject
          end
        end

        resource :friends do 
          mount Api::V1::Friends::All 
        end 
      end
    end
  end
end