module Api 
  module V1 
    module Rankings
      class CreditorsRanking < Base 

        desc 'Creditors ranking'
  
        params do 
          optional :filters, type: Hash do 
            optional :creditors_ids, type: Array[Integer], values: -> { User.ids }
            optional :trust_points, type: Hash do 
              requires :min, type: Float, values: ->(v) { v > 0.0 }
              requires :max, type: Float, values: ->(v) { v > 0.0 }
            end
            optional :credits_quantity, type: Symbol, values: %i[ most_to_least least_to_most ]
            optional :ratio,            type: Symbol, values: %i[ highest_to_lowest lowest_to_highest ]
            mutually_exclusive :credits_quantity, :ratio
          end 
        end

        resource :creditors do 
          get do
            ranking_positions = ::Rankings::CreditorsRankingService.call
            queried_object = ::Rankings::CreditorsRankingQuery.new(ranking_positions, params[:filters], params[:pagination]).filter
            ::Ranking::CreditorsRankingSerializer.new(queried_object).serializable_hash
          end
        end 
      end
    end
  end
end