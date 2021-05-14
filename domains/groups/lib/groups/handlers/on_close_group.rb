module Groups 
  module Handlers 
    class OnCloseGroup
      def call(command)
        group_uid = command.data[:group_uid]

        repository = Repositories::Group.new
        repository.with_group(group_uid) do |group|
          group.close_group(command.data)
        end
      end
    end
  end
end