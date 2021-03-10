require 'aggregate_root'

module TransactionPoints
  class TransactionPointAggregate 
    include AggregateRoot
    def initialize(id)
      @id = id
      @status = nil 
      @credibility_points = nil
      @faith_points = nil
      @debtor_id = nil 
      @creditor_id = nil 
    end

    def calculate_credibility_points(params)
      calculation = Calculators::CalculateCredibilityPoints.new(params[:debtor_id], params[:due_money]).call
      
      apply Events::CredibilityPointsCalculated.strict(
        {
          transaction_uid: @id,
          credibility_points: calculation,
          debtor_id: params[:debtor_id]
        }
      )
    end

    def calculate_faith_points(params)
      calculation = Calculators::CalculateFaithPoints.new(params[:creditor_id], params[:due_money]).call

      apply Events::FaithPointsCalculated.strict(
        {
          transaction_uid: @id,
          faith_points: calculation,
          creditor_id: params[:creditor_id]
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

    def allot_faith_points(params)
      apply Events::CredibilityPointsAlloted.strict(
        {
          transaction_uid: @id,
          faith_points: @faith_points,
          creditor_id: @creditor_id
        }
      )
    end

    on Events::CredibilityPointsCalculated do |event|
      @credibility_points = event.data.fetch(:credibility_points)
      @status = :credibility_points_calculated
      @debtor_id = event.data.fetch(:debtor_id)
    end

    on Events::FaithPointsCalculated do |event|
      @faith_points = event.data.fetch(:faith_points)
      @status = :faith_points_calculated
      @creditor_id = event.data.fetch(:creditor_id)
    end
  end
end