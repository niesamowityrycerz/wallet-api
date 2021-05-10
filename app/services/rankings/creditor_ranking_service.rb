module Rankings
  class CreditorRankingService
    def self.call
      ReadModels::Rankings::CreditorRanking.order("ratio DESC")
    end
  end
end