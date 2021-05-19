module ReadModels
  module Rankings 
    class CreditorRankingProjection < ApplicationRecord

      private 

      before_update do 
        self.ratio = (self.trust_points / self.credits_quantity).round(2) || 0.0
      end
    end
  end 
end 
