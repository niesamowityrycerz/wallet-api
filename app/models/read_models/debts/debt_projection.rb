module ReadModels
  module Debts
    class DebtProjection < ApplicationRecord
      #has_one :debt, class_name: 'WriteModels::Debt'
      
      enum status: { pending: 0, accepted: 1, rejected: 2, under_scrutiny: 3, 
                     closed: 4, corrected: 5, settled: 6, expired: 7, debtors_terms_added: 8,
                     points_alloted: 9, penalty_points_alloted: 10 }

      validates :doubts, length: { maximum: 50, too_long: "%{count} characters is maximum!" }

      def total_accepted()
        DebtProjection.accepted.count
      end

      def total_closed()
        DebtProjection.closed.count
      end

      def total_rejected()
        DebtProjection.rejected.count
      end

    end
  end
end

