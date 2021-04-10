class AllTransactionsSerializer < BaseTransactionSerializer
  include JSONAPI::Serializer
  
  link :detailed_info do |transaction|
    "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}"
  end
  
end
