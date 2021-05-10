module Api 
  module V1 
    module Groups 
      class Register < Base 

        before do 
          authenticate_user!
        end

        desc 'Register group'

        params do 
          requires :invited_users, type: Array[Integer], values: -> { User.ids } 
          requires :group_name, type: String 
          requires :from, type: Date 
          requires :to, type: Date 
        end

        resource :register do 
          post do
            command = ::Services::RegisterGroupService.new(params.call)
            Rails.configuration.command_bus.call(command)
            status 201
            redirect "/group/#{params[:group_uid]}"
          end
        end
      end
    end
  end
end