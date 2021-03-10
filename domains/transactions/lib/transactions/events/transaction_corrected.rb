module Transactions
  module Events
    class TransactionCorrected < Event 
      SCHEMA = {
        transaction_uid: String,
        amount: [ :optional, Float ],
        description: [ :optional, String ],
        currency_id: [ :optional, Integer ],
        date_of_transaction: [ :optional, Date ],
        status: Symbol
      }
    end
  end
end