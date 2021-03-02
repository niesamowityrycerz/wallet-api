module Transactions
  class TransactionAggregate
    include AggregateRoot

    def initialize(id)
      @id = id
      @state = nil
    end

    def place(params)
      binding.pry
      apply Events::TransactionIssued.strict( 
        { 
          issuer_uid: params[:issuer_uid],
          borrower_name: params[:borrower_name],
          issuer_id: params[:issuer_id],
          amount: params[:amount],
          transaction_uid: params[:transaction_uid],
          description: params[:description]
        }
      )
      binding.pry
    end

    on Events::TransactionIssued do |event|
      binding.pry
      @state = :initialized
    end

  end
end