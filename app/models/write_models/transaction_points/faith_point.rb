module WriteModels
  module TransactionPoints
    class FaithPoint < ApplicationRecord
      belongs_to :creditor, class_name: 'User', foreign_key: 'creditor_id'
      belongs_to :transaction_projection, class_name: 'ReadModels::Transactions::TransactionProjection'
    end
  end
end

