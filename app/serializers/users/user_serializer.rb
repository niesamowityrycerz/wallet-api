module Users 
  class UserSerializer
    include JSONAPI::Serializer
    
    attributes :username, :email

    attributes :adjusted_credibility_points do |user|
      debt = ReadModels::Transactions::TransactionProjection.where(debtor_id: user.id)
      debt.sum("adjusted_credibility_points")
    end

    attributes :penalty_points do |user|
      debt = ReadModels::Transactions::TransactionProjection.where(debtor_id: user.id)
      debt.sum("penalty_points")
    end

    attributes :credibility_points do |user|
      debt = ReadModels::Transactions::TransactionProjection.where(debtor_id: user.id)
      debt.sum("credibility_points")
    end

    attributes :trust_points do |user|
      debt = ReadModels::Transactions::TransactionProjection.where(creditor_id: user.id)
      debt.sum("trust_points")
    end

    attribute :accepted_counter do |user|
      debt = ReadModels::Transactions::TransactionProjection.where("(debtor_id = ? OR creditor_id = ?) AND status = ?", user.id, user.id, "accepted")
      debt.count 
    end

    attribute :pending_counter do |user|
      debt = ReadModels::Transactions::TransactionProjection.where("(debtor_id = ? OR creditor_id = ?) AND status = ?", user.id, user.id, "pending")
      debt.count 
    end

    attributes :total_closed do |user|
      debt = ReadModels::Transactions::TransactionProjection.where("(debtor_id = ? OR creditor_id = ?) AND status = ?", user.id, user.id, "closed")
      debt.count 
    end

    attributes :borrow_transactions do |user|
      debt = ReadModels::Transactions::TransactionProjection.where("debtor_id = ?", user.id)
      debt.count
    end

    attribute :lend_transactions do |user|
      debt = ReadModels::Transactions::TransactionProjection.where("creditor_id = ?", user.id)
      debt.count
    end

    attributes :lend_by_date do |user|
      ReadModels::Transactions::TransactionProjection.where("debtor_id = ? OR creditor_id = ?", user.id, user.id).group("date_of_transaction").count
    end
  end 
end 

