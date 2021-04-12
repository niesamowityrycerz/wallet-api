module Transactions
  class TransactionSerializer < BaseTransactionSerializer
    include JSONAPI::Serializer

    attributes :description, :date_of_transaction

    attribute :transaction_doubts, if: Proc.new { |transaction|
      transaction.doubts != nil 
    } do |transaction|
      transaction.doubts 
    end

    attribute :settlement_method do |transaction|
      SettlementMethod.find_by!(id: transaction.settlement_method_id).name
    end

    attribute :max_date_of_settlement, if: Proc.new { |transaction, params|
      params[:current_user].admin || params[:current_user].id == transaction.debtor_id
    } 

    link :accept, if: Proc.new { |transaction, params|
      (%w[pending corrected].include? transaction.status) && (params[:current_user].id == transaction.debtor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/accept"
    end

    link :reject, if: Proc.new { |transaction, params|
      (!%w[accepted settled rejected closed].include? transaction.status) && (params[:current_user].id == transaction.debtor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/reject"
    end

    link :correct, if: Proc.new { |transaction, params|
      (transaction.status == "under_scrutiny") && (params[:current_user].id == transaction.creditor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/correct"
    end

    link :check_out, if: Proc.new { |transaction, params|
      (%w[pending corrected under_scrutiny].include? transaction.status) && (params[:current_user].id == transaction.debtor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/checkout"
    end

    link :close, if: Proc.new { |transaction, params| 
      (transaction.status != "closed") && (params[:current_user].id == transaction.creditor_id)
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/close"
    end

    link :settle, if: Proc.new { |transaction, params|
      params[:current_user].id == transaction.creditor_id 
    } do |transaction|
      "localhost:3000/api/v1/transaction/#{transaction.transaction_uid}/settle"
    end
  end 
end