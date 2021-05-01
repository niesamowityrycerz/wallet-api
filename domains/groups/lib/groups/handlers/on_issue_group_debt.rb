module Groups
  module Handlers 
    class OnIssueGroupDebt
      def call(command)
        group_uid = command.data.fetch(:group_uid)

        repository = Repositories::Group.new 
        repository.with_group(group_uid) do |group_debt|
          group_debt.issue_group_debt(command.data)
        end
      end
    end
  end
end