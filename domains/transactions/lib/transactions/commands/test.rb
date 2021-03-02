module Transactions
  module Commands
    class Test 
      def initialize(name)
        @name = name
      end

      def self.hello(name)
        puts "Hello #{name}"
      end
      
    end
  end
end