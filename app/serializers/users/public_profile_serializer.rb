module Users 
  class PublicProfileSerializer < BaseProfileSerializer
    include JSONAPI::Serializer
    
    attributes :debts_between_users do |user, params|
      unwanted_columnes = [ "penalty_points", "credibility_points", "adjusted_credibility_points", "anticipated_date_of_settlement", "trust_points", "reason_for_rejection",
                            "reason_for_closing", "max_date_of_settlement", "doubts"]
      selected_columns = ReadModels::Debts::DebtProjection.column_names - unwanted_columnes
      visitor_debts = ReadModels::Debts::DebtProjection.select(selected_columns).where("debtor_id = ? AND creditor_id = ?", params[:profile_visitor].id, user.id).last(5)
      visited_user_debts =  ReadModels::Debts::DebtProjection.select(selected_columns).where("debtor_id = ? AND creditor_id = ?", user.id, params[:profile_visitor].id).last(5)
      visitor_debts + visited_user_debts
    end

    link :balance_debts, if: Proc.new { |user, params|
      visitor_credits = ReadModels::Debts::DebtProjection.where("creditor_id = ? AND debtor_id = ?", params[:profile_visitor].id, user.id).accepted
      visitor_debts  = ReadModels::Debts::DebtProjection.where("creditor_id = ? AND debtor_id = ?", user.id, params[:profile_visitor].id).accepted
      visitor_debts.sum('amount') > visitor_credits.sum('amount')
    } do |object|
      "/api/v1/users/#{object.id}/balance"
    end 


    meta do |user, params|
      debts = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND creditor_id = ?", params[:profile_visitor].id, user.id)
      credits =  ReadModels::Debts::DebtProjection.where("debtor_id = ? AND creditor_id = ?", user.id, params[:profile_visitor].id)
      {
        visitor_sum_of_accepted_debts: debts.accepted.sum('amount').round(2),
        visitor_sum_of_acceted_credits: credits.accepted.sum('amount').round(2),
        debts_quantity: debts.count,
        credits_quantity: credits.count,
      }
    end

  end 
end 
