module Rankings
  class DebtorsRankingService
    def self.call 
      WriteModels::DebtorsRanking.order("ratio DESC")
    end
  end
end