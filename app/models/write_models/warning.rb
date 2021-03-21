module WriteModels
  class Warning < ApplicationRecord
    belongs_to :user
    belongs_to :warning_type

    has_many :transaction_warnings 
    has_many :financial_transactions, class_name: 'WriteModels::FinancialTransaction', through: :transaction_warnings
  end
end

