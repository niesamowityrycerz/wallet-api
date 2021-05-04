module Api 
  module V1 
    module Users
      class CreditorsRanking < Base 
        desc 'Creditors ranking'

        resource :creditors_ranking do 
          get do
            creditors_ranking = WriteModels::CreditorsRanking.order("trust_points DESC")
            ::Ranking::CreditorsRankingSerializer.new(creditors_ranking).serializable_hash
          end
        end 
      end
    end
  end
end