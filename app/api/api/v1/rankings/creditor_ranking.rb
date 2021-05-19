module Api 
  module V1 
    module Rankings
      class CreditorRanking < Base 

        desc 'Creditor ranking'
  
        params do 
          optional :filters, type: Hash do 
            optional :creditor_id, type: Integer, values: -> { User.ids }
            optional :trust_points, type: Hash do 
              requires :min, type: Float, values: (0.0..1000.0)
              requires :max, type: Float, values: (0.0..1000.0)
            end
            optional :credits_quantity, type: Symbol, values: %i[ most_to_least least_to_most ]
            optional :ratio,            type: Symbol, values: %i[ highest_to_lowest lowest_to_highest ]
            mutually_exclusive :credits_quantity, :ratio
          end 
        end

        resource :creditors do 
          get do
            ranking_positions = ::Rankings::CreditorRankingService.call
            queried_object = ::Rankings::CreditorRankingQuery.new(ranking_positions, params[:filters], params[:pagination]).filter
            ::Rankings::CreditorRankingSerializer.new(queried_object).serializable_hash
          end
        end 
      end
    end
  end
end