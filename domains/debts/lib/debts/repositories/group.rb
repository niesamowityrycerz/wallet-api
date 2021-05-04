module Debts
  module Repositories
    class Group 
      def with_group(group_uid)
        Groups::Repositories::Group.new.with_group_data(group_uid)
      end
    end
  end
end