module Users
  class DebtorsRankingService
    def self.call 
      WriteModels::DebtorsRanking.order("adjusted_credibility_points DESC")
    end
  end
end