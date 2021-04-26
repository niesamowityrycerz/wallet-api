module Groups 
  module Commands 
    class IssueGroupTransaction < Command 
      SCHEMA = {
        group_transaction_uid: String,
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