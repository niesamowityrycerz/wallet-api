class TransactionWarning < ApplicationRecord
  belongs_to :financial_transaction
  belongs_to :warning
end
