module ReadModels
  module Transactions 
    class TransactionProjection < ApplicationRecord
      has_one :credibility_point, class_name: 'WriteModels::CredibilityPoint'
      has_one :trust_point
      has_one :financial_transaction, class_name: 'WriteModels::FinancialTransaction'
      
      # status column is of type Integer;
      # Rails will do the mapping and transalte: 
      # 0 -> pending, 1 -> rejected, 2 -> accepted, 3 -> closed, 4 -> corrected, 5 -> :settled
      # enum status: { pending: 0, accepted: 1, rejected: 2, closed: 3 }, default: :pending 
      enum status: { pending: 0, accepted: 1, rejected: 2, closed: 3, corrected: 4, 
                     settled: 5, expired: 6, points_alloted: 7, 
                     penalty_points_alloted: 8, passed_to_admin: 9 }
      # error.messages = '50 characters is maximum!'
      validates :doubts, length: { maximum: 50, too_long: "%{count} characters is maximum!" }      
    end
  end
end

