module Debts
  class DebtSerializer < BaseDebtSerializer
    include JSONAPI::Serializer

    attributes :description, :date_of_transaction

    attribute :debt_doubts, if: Proc.new { |debt|
      debt.doubts != nil 
    } do |debt|
      debt.doubts 
    end

    attribute :adjusted_credibility_points, if: Proc.new { |debt, params|
      debt.closed? && (params[:current_user].id == debt.debtor_id || params[:current_user].admin)
    } do |debt|
      debt.adjusted_credibility_points.nil? ? 0.0 : debt.adjusted_credibility_points
    end

    attribute :credibility_points, if: Proc.new { |debt, params|
      debt.closed? && (params[:current_user].id == debt.debtor_id || params[:current_user].admin)
    } do |debt|
      debt.credibility_points.nil? ? 0.0 : debt.credibility_points
    end

    attribute :penalty_points, if: Proc.new { |debt, params| 
      debt.closed? && (params[:current_user].id == debt.debtor_id || params[:current_user].admin)
    } do |debt|
      debt.penalty_points.nil? ? 0.0 : debt.penalty_points
    end

    attribute :trust_points, if: Proc.new { |debt, params|
      debt.closed? && (params[:current_user].id == debt.creditor_id || params[:current_user].admin)
    } do |debt|
      debt.trust_points.nil? ? 0.0 : debt.trust_points
    end

    attribute :expire_in, if: Proc.new { |debt|
      Date.today <= debt.max_date_of_settlement && !debt.closed?
    } do |debt|
      today = Date.today 
      expire_on = debt.max_date_of_settlement
      "#{(expire_on - today).to_i} days"
    end 

    attribute :settlement_method do |debt|
      SettlementMethod.find_by!(id: debt.settlement_method_id).name
    end

    attribute :max_date_of_settlement, if: Proc.new { |debt, params|
      params[:current_user].admin || params[:current_user].id == debt.debtor_id
    } 

    link :accept, if: Proc.new { |debt, params|      
      (debt.pending? || debt.corrected?) && (params[:current_user].id == debt.debtor_id)
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/accept"
    end

    link :reject, if: Proc.new { |debt, params|
      (!%w[accepted settled rejected closed].include? debt.status) && (params[:current_user].id == debt.debtor_id)
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/reject"
    end

    link :correct, if: Proc.new { |debt, params|
      debt.under_scrutiny? && (params[:current_user].id == debt.creditor_id)
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/correct"
    end

    link :check_out, if: Proc.new { |debt, params|
      (%w[pending corrected under_scrutiny].include? debt.status) && (params[:current_user].id == debt.debtor_id)
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/checkout"
    end

    link :close, if: Proc.new { |debt, params| 
      !debt.closed? && (params[:current_user].id == debt.creditor_id)
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/close"
    end

    link :settle, if: Proc.new { |debt, params|
      (params[:current_user].id == debt.debtor_id) && debt.accepted?
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/settle"
    end
    
    link :fill_settlement_terms, if: Proc.new { |debt, params|
      debt.debtor_id == params[:current_user].id && debt.accepted?
    } do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}/fill_settlement_terms"
    end
  end 
end