module Debts
  class BaseDebtSerializer 
    include JSONAPI::Serializer

    attributes :amount, :status

    attribute :currency do |debt|
      Currency.find_by!(id: debt.currency_id).code
    end

    attribute :debtor do |debt|
      User.find_by!(id: debt.debtor_id).username
    end

    attribute :creditor do |debt|
      User.find_by!(id: debt.creditor_id).username
    end

    attribute :issued_at do |debt|
      debt.created_at.to_date
    end

    attribute :maturity_on do |debt|
      debt.max_date_of_settlement
    end

  end 
end 
