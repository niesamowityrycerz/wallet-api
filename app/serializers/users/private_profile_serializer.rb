module Users 
  class PrivateProfileSerializer < BaseProfileSerializer
    include JSONAPI::Serializer
    
    attributes :adjusted_credibility_points do |user|
      debt = ReadModels::Debts::DebtProjection.where(debtor_id: user.id)
      debt.sum("adjusted_credibility_points")
    end

    attributes :penalty_points do |user|
      debt = ReadModels::Debts::DebtProjection.where(debtor_id: user.id)
      debt.sum("penalty_points")
    end

    attributes :credibility_points do |user|
      debt = ReadModels::Debts::DebtProjection.where(debtor_id: user.id)
      debt.sum("credibility_points")
    end

    attributes :trust_points do |user|
      debt = ReadModels::Debts::DebtProjection.where(creditor_id: user.id)
      debt.sum("trust_points")
    end

    attribute :accepted_debts_quantity do |user|
      debt = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND status = ?", user.id, "accepted")
      debt.count 
    end

    attribute :pending_debts_quantity do |user|
      debt = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND status = ?", user.id, "pending")
      debt.count 
    end

    attributes :closed_debts_quantity do |user|
      debt = ReadModels::Debts::DebtProjection.where("debtor_id = ?  AND status = ?", user.id, "closed")
      debt.count 
    end

    attribute :given_credits do |user|
      credits = ReadModels::Debts::DebtProjection.where("creditor_id = ?", user.id)
      credits.count
    end

    attributes :given_credits_by_date do |user|
      ReadModels::Debts::DebtProjection.where("debtor_id = ? OR creditor_id = ?", user.id, user.id).group("date_of_transaction").count
    end

    attributes :sum_of_accepted_debts do |user|
      accepted_debts = ReadModels::Debts::DebtProjection.where("debtor_id = ?", user.id)
      accepted_debts.sum("amount").round(2)
    end

    attributes :sum_of_accepted_given_credits do |user|
      accepted_credits = ReadModels::Debts::DebtProjection.where("creditor_id = ?", user.id)
      accepted_credits.sum("amount").round(2)
    end

    link :accept_invitation_to_group do |user|

    end
    
  end 
end 

