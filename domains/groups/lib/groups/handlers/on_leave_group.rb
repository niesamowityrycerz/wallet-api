module Groups 
  module Handlers 
    class OnLeaveGroup
      def call(command)
        group_uid = command.data.fetch(:group_uid)

        repository = Repositories::Group.new
        repository.with_group(group_uid) do |group|
          group.leave_group(command.data)
        end
      end
    end
  end
end