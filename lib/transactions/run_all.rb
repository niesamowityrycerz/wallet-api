module Transactions
  class RunAll
    def initialize(users=1,per_user_transaction=1, to_accept_quantity=1)
      @users = users
      @per_user_transaction = per_user_transaction
      @accept_quantity = to_accept_quantity
    end

    def call
      create_players(@users)
      add_repayment_methods(@users)

      
      issue_transaction(@per_user_transaction)
      Transactions::AcceptTransaction.new(get_transaction_uids, @accept_quantity).call
    end

    private 

    def create_players(quantity)
      quantity.times do |i|
        User.create!({
          username: Faker::Internet.username + i.to_s,
          email: Faker::Internet.email,
          password: 'password1',
          password_confirmation: 'password1'
        })
      end 
    end

    def add_repayment_methods(_players)
      User.ids.each do |creditor|
        WriteModels::RepaymentCondition.create!(
          {
            maturity_in_days: rand(1..5),
            creditor_id: creditor,
            currency_id: Currency.ids.sample,
            settlement_method_id: SettlementMethod.find_by!(name: 'one instalment').id,
          }
        )
      end
    end

    def issue_transaction(per_user_transaction)
      User.ids.each do |creditor|
        debtors = User.ids.select! { |id| id != creditor }
        IssueTransaction.new(creditor, debtors, per_user_transaction).call
      end
    end

    def get_transaction_uids(quantity=1)
      transaction_uids = []
      ReadModels::Transactions::TransactionProjection.all.each do |transaction|
        transaction_uids << transaction.transaction_uid
      end
      transaction_uids
    end


  end
end