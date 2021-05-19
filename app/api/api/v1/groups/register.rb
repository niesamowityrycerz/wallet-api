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
          requires :group_name, type: String, message: 'is missing'
          requires :from, type: Date, values: ->(val) { val >= Date.today}
          requires :to, type: Date ,  values: ->(val) { val >= Date.today}
        end

        resource :register do 
          post do
            group = ::Groups::RegisterGroupService.new(params, current_user)
            group.register
            redirect "/api/v1/group/#{params[:group_uid]}"
          end
        end
      end
    end
  end
end