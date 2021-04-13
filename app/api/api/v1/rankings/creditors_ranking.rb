module Api 
  module V1 
    module Rankings
      class CreditorsRanking < Base 

        resource :creditors do 
          get do 
            ranking = WriteModels::CreditorsRanking.all
            ranking.order("trust_points DESC")
            
          end
        end
      end
    end
  end
end