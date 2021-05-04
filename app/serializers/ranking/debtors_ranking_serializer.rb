module Ranking
  class DebtorsRankingSerializer
    include JSONAPI::Serializer 

    attributes :adjusted_credibility_points, :debts_quantity

    attribute :debtor do |position|
      debtor = User.find_by!(id: position.debtor_id)
      debtor.username
    end
    
    attribute :ratio, if: Proc.new { |entity|
      entity.debts_quantity > 0
    } do |position|
      (position.adjusted_credibility_points / position.debts_quantity).round(2)
    end
    
  end
end