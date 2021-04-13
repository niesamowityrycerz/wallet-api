module Api 
  module V1 
    module Rankings
      class DebtorsRanking < Base 

        resource :debtors do 
          get do 
            ranking = WriteModels::DebtorsRanking.all
            ranking.order("adjusted_credibility_points DESC")
          end
        end
      end
    end
  end
end