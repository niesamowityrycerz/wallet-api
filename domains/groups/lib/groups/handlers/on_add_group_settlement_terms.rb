module Groups
  module Handlers
    class OnAddGroupSettlementTerms
      def call(command)
        group_uid = command.data[:group_uid]

        reposiotry = Repositories::Group.new
        reposiotry.with_group(group_uid) do |group|
          group.add_group_terms(command.data)
        end

      end
    end
  end
end