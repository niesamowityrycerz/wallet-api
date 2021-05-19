module Rankings
  class CreditorRankingService
    def self.call
      ReadModels::Rankings::CreditorRankingProjection.order("ratio DESC")
    end
  end
end