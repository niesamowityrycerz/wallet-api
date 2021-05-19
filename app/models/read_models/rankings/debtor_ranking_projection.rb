module ReadModels 
  module Rankings 
    class DebtorRankingProjection < ApplicationRecord

      private 

      before_update do 
        self.ratio = (self.adjusted_credibility_points / self.debts_quantity).round(2) || 0.0
      end
    end
  end 
end 
