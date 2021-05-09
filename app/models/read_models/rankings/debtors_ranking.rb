module ReadModels 
  module Rankings 
    class DebtorsRanking < ApplicationRecord
      self.table_name = 'debtors_ranking'

      private 

      before_update do 
        self.ratio = (self.adjusted_credibility_points / self.debts_quantity).round(2)
      end
    end
  end 
end 
