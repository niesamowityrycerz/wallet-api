module Debts 
  module Commands
    class IssueDebt < Command 
      SCHEMA = {
        debt_uid: String,
        creditor_id: Integer,
        debtor_id: Integer,
        amount: Float,
        description: String,
        currency_id: Integer,
        date_of_transaction: [ :optional, Date ],
        group_uid: [ :optional, String]
      }
    end
  end
end