module Ranking 
  class CreditorsRankingSerializer
    include JSONAPI::Serializer 

    attribute :trust_points, :credit_transactions

    attribute :creditor do |entity|
      user = User.find_by!(id: entity.creditor_id)
      user.username
    end

    attribute :ratio, if: Proc.new { |entity|
      entity.credit_transactions > 0
    } do |position|
      (position.trust_points / position.credit_transactions).round(2)
    end
  end
end