module CredibilityPoints
  module Commands
    class AddPenaltyPoints < Command 
      SCHEMA = {
        transaction_uid: String,
        debtor_id: Integer,
        warning_type_id: Integer,
        warning_uid: String
      }
    end
  end
end