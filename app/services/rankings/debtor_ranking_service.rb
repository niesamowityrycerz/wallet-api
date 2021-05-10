module Rankings
  class DebtorRankingService
    def self.call 
      ReadModels::Rankings::DebtorRanking.order("ratio DESC")
    end
  end
end