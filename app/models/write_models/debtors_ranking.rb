module WriteModels 
  class DebtorsRanking < ApplicationRecord
    self.table_name = 'debtors_ranking'
    belongs_to :debtor, class_name: 'User'

    private 

    before_update do 
      self.ratio = (self.adjusted_credibility_points / self.debts_quantity).round(2)
    end
  end
end 
