module WriteModels 
  class FinancialTransaction < ApplicationRecord
    belongs_to :transaction_projection, class_name: 'ReadModels::Transactions::TransactionProjection'
    belongs_to :debtor,   class_name: 'User'
    belongs_to :creditor, class_name: 'User'

    has_many :transaction_warnings 
    has_many :warnings, class_name: 'WriteModels::Warning', through: :transaction_warnings
  end 
end
