module Groups 
  module Commands 
    class IssueGroupDebt < Command 
      SCHEMA = {
        group_debt_uid: String,
        issuer_id: Integer,
        recievers_ids: [[Integer]],
        total_amount: Float,
        description: String,
        date_of_transaction: [ :optional, Date ],
        group_uid: String
      }
    end
  end
end