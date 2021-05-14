module Groups
  module Calculators 
    class GetNewLeader
      def self.set(members)
        if members.empty? 
          nil
        else 
          members.sample.id
        end
      end 
    end
  end
end