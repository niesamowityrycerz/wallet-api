module Transactions
  class RunAll
    def initialize(per_user_transaction=1)
      @per_user_transaction = per_user_transaction
    end

    def call(accept_q=1, reject_q=1, settle_q=1, checkout_q=1)
      issue_transaction(@per_user_transaction)
      @transactions = ReadModels::Transactions::TransactionProjection.all 

      Transactions::AcceptTransaction.new(to_accept(accept_q)).call
      Transactions::RejectTransaction.new(to_reject(reject_q)).call
      Transactions::SettleTransaction.new(to_reject(settle_q), not_on_time = 5).call
      Transactions::CheckOutTransaction.new(to_checkout_and_correct(checkout_q)).call
      Transactions::CorrectTransaction.new(to_checkout_and_correct(checkout_q)).call

    end

    private 

    def issue_transaction(per_user_transaction)
      User.ids.each do |creditor|
        debtors = User.ids.select! { |id| id != creditor }
        IssueTransaction.new(creditor, debtors, per_user_transaction).call
      end
    end

    def to_accept(q)
      accept = @transactions.sample(q)
      @transactions -= accept
      get_transaction_uids(accept)
    end 

    def to_reject(q)
      reject = @transactions.sample(q)
      @transactions -= reject 
      get_transaction_uids(reject)
    end 

    def to_settle(q)
      settle = @transactions.sample(q)
      @transactions -= settle 
      get_transaction_uids(settle)
    end

    def to_checkout_and_correct(q)
      checkout = @transactions.sample(q)
      @transactions -= checkout 
      get_transaction_uids(checkout)
    end

    def get_transaction_uids(transactions)
      transaction_uids = []
      transactions.each do |tran|
        transaction_uids << tran.transaction_uid
      end
      transaction_uids
    end


  end
end