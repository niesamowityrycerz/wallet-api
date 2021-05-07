class DebtorsRankingQuery 
  def initialize(positions)
    @positions = positions
  end

  def call 
    @positions.order("adjusted_credibility_points DESC")
  end
end