module Rankings
  class CreditorsRankingService
    def self.call
      WriteModels::CreditorsRanking.order("ratio DESC")
    end
  end
end