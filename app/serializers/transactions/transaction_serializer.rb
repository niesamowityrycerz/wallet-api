module Transactions
  class TransactionSerializer < BaseTransactionSerializer
    include JSONAPI::Serializer

    attributes :description, :date_of_transaction

    attribute :transaction_doubts, if: Proc.new { |transaction|
      transaction.doubts != nil 
    } do |transaction|
      transaction.doubts 
    end

    attribute :adjusted_credibility_points, if: Proc.new { |transaction, params|
      transaction.closed? && (params[:current_user].id == transaction.debtor_id || params[:current_user].admin)
    } do |transaction|
      transaction.adjusted_credibility_points.nil? ? 0.0 : transaction.adjusted_credibility_points
    end

    attribute :credibility_points, if: Proc.new { |transaction, params|
      transaction.closed? && (params[:current_user].id == transaction.debtor_id || params[:current_user].admin)
    } do |transaction|
      transaction.credibility_points.nil? ? 0.0 : transaction.credibility_points
    end

    attribute :penalty_points, if: Proc.new { |transaction, params| 
      transaction.closed? && (params[:current_user].id == transaction.debtor_id || params[:current_user].admin)
    } do |transaction|
      transaction.penalty_points.nil? ? 0.0 : transaction.penalty_points
    end

    attribute :trust_points, if: Proc.new { |transaction, params|
      transaction.closed? && (params[:current_user].id == transaction.creditor_id || params[:current_user].admin)
    } do |transaction|
      transaction.trust_points.nil? ? 0.0 : transaction.trust_points
    end

    attribute :expire_in, if: Proc.new { |transaction|
      Date.today <= transaction.max_date_of_settlement && !transaction.closed?
    } do |transaction|
      today = Date.today 
      expire_on = transaction.max_date_of_settlement
      "#{(expire_on - today).to_i} days"
    end 

    attribute :settlement_method do |transaction|
      SettlementMethod.find_by!(id: transaction.settlement_method_id).name
    end

    attribute :max_date_of_settlement, if: Proc.new { |transaction, params|
      params[:current_user].admin || params[:current_user].id == transaction.debtor_id
    } 

    link :accept, if: Proc.new { |transaction, params|      
      (transaction.pending? || transaction.corrected?) && (params[:current_user].id == transaction.debtor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/accept"
    end

    link :reject, if: Proc.new { |transaction, params|
      (!%w[accepted settled rejected closed].include? transaction.status) && (params[:current_user].id == transaction.debtor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/reject"
    end

    link :correct, if: Proc.new { |transaction, params|
      transaction.under_scrutiny? && (params[:current_user].id == transaction.creditor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/correct"
    end

    link :check_out, if: Proc.new { |transaction, params|
      (%w[pending corrected under_scrutiny].include? transaction.status) && (params[:current_user].id == transaction.debtor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/checkout"
    end

    link :close, if: Proc.new { |transaction, params| 
      !transaction.closed? && (params[:current_user].id == transaction.creditor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/close"
    end

    link :settle, if: Proc.new { |transaction, params|
      (params[:current_user].id == transaction.debtor_id) && transaction.? 
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/settle"
    end
    
    link :fill_settlement_terms, if: Proc.new { |transaction, params|
      transaction.debtor_id == params[:current_user].id && transaction.accepted?
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction.uid}/fill_settlement_terms"
    end
  end 
end