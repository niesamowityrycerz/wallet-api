module Transactions
  class BaseTransactionSerializer 
    include JSONAPI::Serializer

    attributes :amount, :status

    attribute :currency do |transaction|
      Currency.find_by!(id: transaction.currency_id).code
    end

    attribute :debtor do |transaction|
      User.find_by!(id: transaction.debtor_id).username
    end

    attribute :creditor do |transaction|
      User.find_by!(id: transaction.creditor_id).username
    end

    attribute :issued_at do |transaction|
      transaction.created_at
    end

    attribute :maturity_on do |transaction|
      transaction.max_date_of_settlement
    end

  end 
end 
