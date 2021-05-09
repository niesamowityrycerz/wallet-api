module ReadModels
  module Rankings 
    class CreditorsRanking < ApplicationRecord
      self.table_name = 'creditors_ranking'

      private 

      before_update do 
        self.ratio = (self.trust_points / self.credits_quantity).round(2)
      end
    end
  end 
end 
