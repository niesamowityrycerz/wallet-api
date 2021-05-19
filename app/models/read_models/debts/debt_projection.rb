module ReadModels
  module Debts
    class DebtProjection < ApplicationRecord
      #has_one :debt, class_name: 'WriteModels::Debt'
      
      enum status: { pending: 'pending', accepted: 'accepted', rejected: 'rejected', under_scrutiny: 'under_scrutiny', 
                     closed: 'closed', corrected: 'corrected', settled: 'settled', expired: 'expired',
                     anticipated_settlement_date_added: 'anticipated_settlement_date_added',
                     points_alloted: 'points_alloted', penalty_points_alloted: 'penalty_points_alloted' }

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

