module Groups
  module Entities 
    class Member 
      def initialize(id)
        @username = User.find_by!(id: id).username
        @id = id 
      end
    end
  end
end