module Users 
  class UserSerializer
    include JSONAPI::Serializer
    
    attributes :username, :email

    attributes :adjusted_credibility_points do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where(debtor_id: user.id)
      @transactions.sum("adjusted_credibility_points")
    end

    attributes :penalty_points do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where(debtor_id: user.id)
      @transactions.sum("penalty_points")
    end

    attributes :credibility_points do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where(debtor_id: user.id)
      @transactions.sum("credibility_points")
    end

    attributes :trust_points do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where(creditor_id: user.id)
      @transactions.sum("trust_points")
    end

    attribute :accepted_counter do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where("(debtor_id = ? OR creditor_id = ?) AND status = ?", user.id, user.id, "accepted")
      @transactions.count 
    end

    attribute :pending_counter do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where("(debtor_id = ? OR creditor_id = ?) AND status = ?", user.id, user.id, "pending")
      @transactions.count 
    end

    attributes :total_closed do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where("(debtor_id = ? OR creditor_id = ?) AND status = ?", user.id, user.id, "closed")
      @transactions.count 
    end

    attributes :borrow_transactions do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where("debtor_id = ?", user.id)
      @transactions.count
    end

    attribute :lend_transactions do |user|
      @transactions = ReadModels::Transactions::TransactionProjection.where("creditor_id = ?", user.id)
      @transactions.count
    end

    attributes :lend_by_date do |user|
      ReadModels::Transactions::TransactionProjection.where("debtor_id = ? OR creditor_id = ?", user.id, user.id).group("date_of_transaction").count
    end
  end 
end 

