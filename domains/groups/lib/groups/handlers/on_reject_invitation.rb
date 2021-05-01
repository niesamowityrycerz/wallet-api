module Groups 
  module Handlers
    class OnRejectInvitation 
      def call(command)
        group_uid = command.data.fetch(:group_uid)

        repository = Repositories::Group.new
        repository.with_group(group_uid) do |user|
          user.reject_invitation(command.data)
        end
      end
    end
  end 
end