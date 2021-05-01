require 'aggregate_root'

module RankingPoints
  class RankingPointAggregate
    include AggregateRoot

    def initialize(id)
      @id = id 
      @due_money = nil
      @creditor_id = nil
      @debtor_id = nil
      @penalty_points = []
      @state = :init
    end

    attr_accessor :credibility_points, :penalty_points, :adjusted_points, :due_money

    def allot_trust_points(params)
      calculation = Calculators::CalculateTrustPoints.new(params[:creditor_id], due_money).call
      apply Events::TrustPointsAlloted.strict(
        {
          debt_uid: @id,
          trust_points: calculation,
          creditor_id: params[:creditor_id],
          state: :points_alloted
        }
      )
    end

    def allot_credibility_points(params)
      credibility_points = Calculators::CalculateCredibilityPoints.new(params[:debtor_id], params[:due_money], params[:expire_on]).call
      penalty_sum = penalty_points.sum { |penalty| penalty.points }
      @adjusted_points = credibility_points - penalty_sum


      apply Events::CredibilityPointsAlloted.strict(
        {
          credibility_points: credibility_points,
          adjusted_credibility_points: adjusted_points,
          debt_uid: @id,
          debtor_id: params[:debtor_id],
          due_money: params[:due_money]
        }
      )
    end

    def add_penalty_points(params)
      calculation = Calculators::CalculatePenaltyPoints.new(params[:warnings_counter], params[:due_money]).call

      apply Events::PenaltyPointsAdded.strict(
        {
          penalty_points: calculation,
          debt_uid: @id,
          debtor_id: params[:debtor_id],
          warning_type_id: params[:warning_type_id],
          warning_uid: params[:warning_uid],
          state: :penalty_points_alloted,
          due_money: params[:due_money]
        }
      )
    end

    on Events::CredibilityPointsAlloted do |event|
      @credibility_points = event.data.fetch(:credibility_points)
      @debtor_id = event.data.fetch(:debtor_id)
      @due_money = event.data.fetch(:due_money)
    end

    on Events::PenaltyPointsAdded do |event|
      @state = :penalty_points_added
      @penalty_points << Entities::PenaltyPoint.new(event.data.fetch(:penalty_points))
    end


    on Events::TrustPointsAlloted do |event|
      @state = event.data.fetch(:state)
    end
  end
end