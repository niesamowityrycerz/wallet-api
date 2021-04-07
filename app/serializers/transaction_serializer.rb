class TransactionSerializer
  include JSONAPI::Serializer
  
  attributes :amount, :status

  attributes :currency_id do |transaction|
    currency = Currency.find_by!(id: transaction.currency_id).code
  end

end
