require 'aggregate_root'

module TrustPoints
  class TrustPointAggregate
    include AggregateRoot 

    def initialize(id)
      @id = id
      @status = nil 
      @trust_points = nil
      @debtor_id = nil 
      @creditor_id = nil 
    end


    def calculate_trust_points(params)
      calculation = Calculators::CalculateTrustPoints.new(params[:creditor_id], params[:due_money]).call

      apply Events::TrustPointsCalculated.strict(
        {
          transaction_uid: @id,
          trust_points: calculation,
          creditor_id: params[:creditor_id],
          status: :trust_points_calculated
        }
      )
    end

    def allot_trust_points(params)
      apply Events::TrustPointsAlloted.strict(
        {
          transaction_uid: @id,
          trust_points: @trust_points,
          creditor_id: @creditor_id
        }
      )
    end

    on Events::TrustPointsCalculated do |event|
      @trust_points = event.data.fetch(:trust_points)
      @status = event.data.fetch(:status)
      @creditor_id = event.data.fetch(:creditor_id)
    end

    on Events::TrustPointsAlloted do |event|
      @status = :alloted
    end

  end
end