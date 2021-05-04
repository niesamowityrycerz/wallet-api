module Ranking 
  class CreditorsRankingSerializer
    include JSONAPI::Serializer 

    attribute :trust_points, :credits_quantity

    attribute :creditor do |position|
      user = User.find_by!(id: position.creditor_id)
      user.username
    end

    attribute :ratio, if: Proc.new { |entity|
      entity.credits_quantity > 0
    } do |position|
      (position.trust_points / position.credits_quantity).round(2)
    end
  end
end