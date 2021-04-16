module Transactions
  class AllTransactionsSerializer < BaseTransactionSerializer
    include JSONAPI::Serializer

    #attributes :total_accepted, :total_closed, :total_rejected

    link :detailed_info do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}"
    end


  end 
end
