module Api 
  module V1 
    module Rankings
      class DebtorRanking < Base 

        desc "Show debtors ranking"

        params do 
          optional :filters, type: Hash do 
            optional :debtors_ids, type: Array[Integer], values: -> { User.ids }
            optional :adjusted_credibility_points, type: Hash do 
              requires :min, type: Float, values: ->(v) { v > 0.0 }
              requires :max, type: Float, values: ->(v) { v > 0.0 }
            end
            optional :debts_quantity,   type: Symbol, values: %i[ most_to_least least_to_most ]
            optional :ratio,            type: Symbol, values: %i[ highest_to_lowest lowest_to_highest ]
            mutually_exclusive :debts_quantity, :ratio
          end 
        end

        resource :debtors do 
          get do 
            ranking_positions = ::Rankings::DebtorRankingService.call
            queried_object = ::Rankings::DebtorRankingQuery.new(ranking_positions, params[:filters], params[:pagination]).filter
            ::Rankings::DebtorRankingSerializer.new(queried_object).serializable_hash
          end
        end
      end
    end
  end
end