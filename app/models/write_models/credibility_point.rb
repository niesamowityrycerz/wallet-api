module WriteModels
  class CredibilityPoint < ApplicationRecord
    belongs_to :debtor, class_name: 'User', foreign_key: 'debtor_id'
    belongs_to :transaction_projection, class_name: 'ReadModels::Transactions::TransactionProjection'
  end 
end
