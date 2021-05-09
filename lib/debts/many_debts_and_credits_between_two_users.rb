module Debts 
  class ManyDebtsAndCreditsBetweenTwoUsers
    def initialize(user_1_id, user_2_id)
      @user_1 = User.find_by!(id: user_1_id)
      @user_2 = User.find_by!(id: user_2_id)
    end

    def call
      build_commands(@user_1, @user_2)
      issue_and_accept_debts(@user_1_credits)
      issue_and_accept_debts(@user_2_credits)
    end

    private 

    def build_commands(user_1, user_2)
      @user_1_credits = []
      @user_2_credits = []
      3.times do |i|
        @user_1_credits << command_base.merge!({
          creditor_id: user_1.id,
          debtor_id: user_2.id
        })

        @user_2_credits << command_base.merge!({
          creditor_id: user_2.id,
          debtor_id: user_1.id
        })
      end
    end

    def command_base
      {
        debt_uid: SecureRandom.uuid,
        amount:      rand(1.0..100.0).round(2),
        description: 'test',
        currency_id: Currency.find_by!(code: 'PLN').id,
        date_of_transaction: Date.today - rand(1..10) 
      }
    end

    def issue_and_accept_debts(commands)
      commands.each do |command|
        Rails.configuration.command_bus.call(
          Debts::Commands::IssueDebt.send(command)
        )
      end 
      debts_uids = retrive_debts_uids(commands)
      accept_debts(debts_uids)
    end

    def retrive_debts_uids(debts)
      uids = []
      debts.each do |h|
        uids << h[:debt_uid]
      end 
      uids
    end

    def accept_debts(debts_uids)
      debts_uids.each do |debt_uid|
        Rails.configuration.command_bus.call(
          Debts::Commands::AcceptDebt.send({
            debt_uid: debt_uid
          })
        )
      end
    end 
  end
end