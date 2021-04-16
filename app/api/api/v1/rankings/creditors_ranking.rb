module Api 
  module V1 
    module Rankings
      class CreditorsRanking < Base 

        desc "Show creditors ranking"

        resource :creditors do 
          get do 
            ranking = WriteModels::CreditorsRanking.all
            queried = ::CreditorsRankingQuery.new(ranking).call
            ::Ranking::CreditorsRankingSerializer.new(queried).serializable_hash
          end
        end
      end
    end
  end
end