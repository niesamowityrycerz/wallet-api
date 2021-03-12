require 'aggregate_root'

module CredibilityPoints
  class CredibilityPointAggregate 
    include AggregateRoot

    def initialize(id)
      @id = id
      @status = nil 
      @credibility_points = nil
      @trust_points = nil
      @debtor_id = nil 
      @creditor_id = nil 
    end

    def calculate_credibility_points(params)
      calculation = Calculators::CalculateCredibilityPoints.new(params[:debtor_id], params[:due_money]).call
      
      apply Events::CredibilityPointsCalculated.strict(
        {
          transaction_uid: @id,
          credibility_points: calculation,
          debtor_id: params[:debtor_id],
          status: :credibility_points_calculated
        }
      )
    end

    def allot_credibility_points(params)
      apply Events::CredibilityPointsAlloted.strict(
        {
          transaction_uid: @id,
          credibility_points: @credibility_points,
          debtor_id: @debtor_id
        }
      )
    end

    def add_penalty_points(params)
      apply Events::PenaltyPointsAdded.strict(
        {
          transaction_uid: @id,
          penalty_points: @credibility_points,
          debtor_id: @debtor_id
        }
      ) 
    end

    

    on Events::CredibilityPointsCalculated do |event|
      @credibility_points = event.data.fetch(:credibility_points)
      @status = event.data.fetch(:status)
      @debtor_id = event.data.fetch(:debtor_id)
    end

    on Events::CredibilityPointsAlloted do |event|
      @status = :alloted
    end

  end
end