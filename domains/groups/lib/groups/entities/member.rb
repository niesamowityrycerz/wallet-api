module Groups
  module Entities 
    class Member 
      def initialize(id)
        @username = User.find_by!(id: id).username
        @id = id 
      end
      
      attr_reader :id
    end
  end
end