module Debts
  class RunAll
    def initialize(per_user_debt=1)
      @per_user_debt = per_user_debt
    end

    def call(accept_q=1, reject_q=1, settle_on_time_q=1, checkout_q=1)
      issue_debt(@per_user_debt)
      @debts = ReadModels::Debts::DebtProjection.pluck(:debt_uid)
      accept_n_settle_uids = to_accept_and_settle(accept_q)
      Debts::AcceptDebt.new(accept_n_settle_uids).call
      Debts::RejectDebt.new(to_reject(reject_q)).call
      Debts::AddAnticipatedSettlementDate.new.call
      Debts::SettleDebt.new(accept_n_settle_uids, settle_on_time_q).call

      Debts::CheckOutDebtDetails.new(to_checkout_and_correct(checkout_q)).call
      Debts::CorrectDebtDetails.new.call

    end

    private 

    def issue_debt(per_user_debt)
      User.ids.each do |creditor|
        debtors = User.ids.select! { |id| id != creditor }
        IssueDebt.new(creditor, debtors, per_user_debt).call
      end
    end

    def to_accept_and_settle(q)
      accept_n_settle = @debts.sample(q)
      @debts -= accept_n_settle
      accept_n_settle
    end 

    def to_reject(q)
      reject = @debts.sample(q)
      @debts -= reject
      reject
    end 

    def to_checkout_and_correct(q)
      checkout = @debts.sample(q)
      @debts -= checkout 
      checkout
    end
  end
end