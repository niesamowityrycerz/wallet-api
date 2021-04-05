module Transactions
  class RunAll
    def initialize(users=1,tran_quantity=1)
      @users = users
      @tran_quantity = tran_quantity
    end

    def call
      create_players(@users)
      add_repayment_methods(User.ids)
      issue_transaction(@tran_quantity)
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

    def add_repayment_methods(players)
      players.each do |creditor|
        WriteModels::RepaymentCondition.create!(
          {
            maturity_in_days: rand(1..5),
            creditor_id: creditor,
            currency_id: Currency.find_by!(code: 'PLN').id,
            settlement_method_id: SettlementMethod.find_by!(name: 'one instalment').id,
          }
        )
      end
    end

    def issue_transaction(per_user_transaction)
      User.ids.each do |creditor|
        debtors = User.ids.select { |id| id != creditor }
        IssueTransaction.new(creditor, debtors, per_user_transaction).call
      end
    end

  end
end