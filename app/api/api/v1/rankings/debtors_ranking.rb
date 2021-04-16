module Api 
  module V1 
    module Rankings
      class DebtorsRanking < Base 

        desc "Show debtors ranking"

        resource :debtors do 
          get do 
            users = User.all.select { |user| user.admin == false }
            ranking = ::DebtorsRankingQuery.new(users)
            ::Ranking::RankingSerializer.new(ranking).serializable_hash

          end
        end
      end
    end
  end
end