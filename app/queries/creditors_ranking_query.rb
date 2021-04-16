class CreditorsRankingQuery 
  def initialize(positions)
    @positions = positions
  end

  def call 
    @positions.order("trust_points DESC")
  end
end