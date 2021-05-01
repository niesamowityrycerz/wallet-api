module Groups
  module Handlers
    class OnRegisterGroup
      def call(command)
        group_uid = command.data[:group_uid]
        
        repository = Repositories::Group.new
        repository.with_group(group_uid) do |group|
          group.register(command.data)
        end
      end
    end
  end
end