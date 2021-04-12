class WarningSerializer < BaseWarningSerializer
  include JSONAPI::Serializer

  attrbute :creditor do |warning|
     transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: warning.transaction_uid)
     creditor = User.find_by!(id: transaction.creditor_id)
     creditor.username
  end

end