module WriteModels 
  class DebtorsRanking < ApplicationRecord
    self.table_name = 'debtors_ranking'
    belongs_to :debtor, class_name: 'User'
  end
end 
