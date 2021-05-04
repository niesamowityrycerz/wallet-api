module Api 
  module V1 
    module Users
      class DebtorsRanking < Base 
        desc 'Debtors ranking'

        resource :debtors_ranking do 
          get do
            debtors_ranking = WriteModels::DebtorsRanking.order("adjusted_credibility_points DESC")
            ::Ranking::DebtorsRankingSerializer.new(debtors_ranking).serializable_hash
          end
        end 
      end
    end
  end
end