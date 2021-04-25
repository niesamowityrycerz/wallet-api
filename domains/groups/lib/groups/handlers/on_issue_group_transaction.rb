module Groups
  module Handlers 
    class OnIssueGroupTransaction
      def call(command)
        group_uid = command.data.fetch(:group_uid)

        repository = Repositories::Group.new 
        repository.with_group(group_uid) do |group_transaction|
          group_transaction.issue_group_transaction(command.data)
        end
      end
    end
  end
end