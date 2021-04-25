module Groups
  module Handlers 
    class OnAcceptInvitation 
      def call(command)
        group_uid = command.data.fetch(:group_uid)

        repository = Repositories::Group.new 
        repository.with_group(group_uid) do |member|
          member.accept_invitation(command.data)
        end
      end
    end
  end
end