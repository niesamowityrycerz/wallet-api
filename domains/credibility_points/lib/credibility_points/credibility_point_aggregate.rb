require 'aggregate_root'

module CredibilityPoints
  class CredibilityPointAggregate 
    include AggregateRoot

    def initialize(id)
      @id = id 
      @status = nil 
      @credibility_points = nil
      @creditor_id = nil
      @due_money = nil
      @penalty_points = []
      @adjusted_points = 0 
    end

    attr_accessor :credibility_points, :penalty_points, :adjusted_points, :due_money

    def calculate_credibility_points(params)
      calculation = Calculators::CalculateCredibilityPoints.new(params[:debtor_id], params[:due_money]).call
      
      apply Events::CredibilityPointsCalculated.strict(
        {
          credibility_points: calculation,
          debtor_id: params[:debtor_id],
          transaction_uid: @id,
          due_money: params[:due_money],
          status: :credibility_points_calculated
        }
      )
    end

    def allot_credibility_points(params)
      penalty_sum = penalty_points.sum { |penalty| penalty.points }
      @adjusted_points = credibility_points - penalty_sum

      apply Events::CredibilityPointsAlloted.strict(
        {
          credibility_points: credibility_points,
          adjusted_credibility_points: adjusted_points,
          transaction_uid: @id,
          debtor_id: @debtor_id
        }
      )
    end


    def add_penalty_points(params)
      calculation = Calculators::CalculatePenaltyPoints.new(params[:warnings_counter], @due_money.amount).call
      binding.pry

      apply Events::PenaltyPointsAdded.strict(
        {
          penalty_points: calculation,
          transaction_uid: @id,
          debtor_id: params[:debtor_id],
          warning_type_id: params[:warning_type_id],
          warning_uid: params[:warning_uid]
        }
      )
    end

    

    on Events::CredibilityPointsCalculated do |event|
      @credibility_points = event.data.fetch(:credibility_points)
      @status = event.data.fetch(:status)
      @debtor_id = event.data.fetch(:debtor_id)
    end

    on Events::CredibilityPointsAlloted do |event|
      @status = :credibility_points_alloted
    end

    # trzeba zmienić, tak aby sie sumuwały te ujemne punkty 
    on Events::PenaltyPointsAdded do |event|
      @status = :penalty_points_added
      @penalty_points << Entities::PenaltyPoint.new(event.data.fetch(:penalty_points))
    end

  end
end