module Warnings
  module ValueObjects
    class WarningType 

      attr_writer :warning_type_id
      
      def initialize(class_name)
        @name = class_name
        @warning_type_id = nil 
      end 

      def call
        if @class_name == 'OnSendMissedDebtRepaymentWarning'
          warning_type_id = WarningType.find_by!(name: 'debt expired').id
        end
      end 

    end
  end
end