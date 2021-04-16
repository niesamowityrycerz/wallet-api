module Ranking
  class DebtorsRankingSerializer 
    include JSONAPI::Serializer 

    attributes :id, :adjusted_credibility_points, :debt_transactions
    
    attribute :ratio, if: Proc.new { |entity|
      entity.debt_transactions > 0
    } do |position|
      (position.adjusted_credibility_points / position.debt_transactions).round(2)
    end


  end
end