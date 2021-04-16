module Ranking
  class RankingSerializer
    include JSONAPI::Serializer

    attribute :username 

    # calls DebtorsRankingSerializer but attribute_to_serialize is nil -> why?
    has_one :debtors_ranking

    #has_one :creditors_ranking 

  end
end