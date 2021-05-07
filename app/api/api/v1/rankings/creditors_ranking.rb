module Api 
  module V1 
    module Rankings
      class CreditorsRanking < Base 

        desc 'Creditors ranking'
  
        params do 
          optional :filters, type: Hash do 
            optional :creditor_id, type: Array[Integer], values: -> { User.ids }
            optional :trust_points, type: Hash do 
              requires :min, type: Float, values: ->(v) { v > 0.0 }
              requires :max, type: Float, values: ->(v) { v > 0.0 }
            end
            optional :credits_quantity, type: Symbol, values: %i[ most_to_leas most_to_least ]
            optional :ratio, type: Symbol, values: %i[ highest_to_lowest lowest_to_higest ]
          end 
        end

        resource :creditors do 
          get do
            binding.pry 
            ranking_positions = ::Users::CreditorsRankingService.call
            queried_object = ::Rankings::CreditorsRankingQuery.new(ranking_positions, params[:filters], params[:pagination]).filter
            binding.pry
            ::Ranking::CreditorsRankingSerializer.new(queried_object).serializable_hash
          end
        end 
      end
    end
  end
end