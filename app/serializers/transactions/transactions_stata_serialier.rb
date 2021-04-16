module Transactions
  class TransactionsStataSerializer 
    include JSONAPI::Serializer 

    binding.pry 

    attribute :accepted_total do |transaction|
      binding.pry 
      transaction.accepted.count 
    end

    attribute :closed_total do |transaction|
      transaction.closed.cont
    end
  end
end