module WriteModels
  class CreditorsRanking < ApplicationRecord
    self.table_name = 'creditors_ranking'
    belongs_to :creditor, class_name: 'User'
  end
end 
