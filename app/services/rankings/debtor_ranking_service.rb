module Rankings
  class DebtorRankingService
    def self.call 
      ReadModels::Rankings::DebtorRankingProjection.order("ratio DESC")
    end
  end
end