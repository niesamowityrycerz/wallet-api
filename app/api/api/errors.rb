module Api 
  module Errors
    extend ActiveSupport::Concern 

    included do 
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!(e, 400)
      end

      rescue_from :all do |e|
        case e.class.name
        when 'Debts::DebtAggregate::DebtNotAccepted'
          error!(e, 403)
        when 'Debts::Repositories::RepaymentCondition::RepaymentConditionsDoNotExist'
          error!(e, 404)
        when 'Debts::DebtAggregate::AnticipatedDateOfSettlementUnavailable'
          error!(e, 403)
        when 'Debts::DebtAggregate::UnableToProceedSettleement'
          error!(e, 403)
        when 'Debts::DebtAggregate::UnableToCheckOutDebtDetails'
          error!(e, 403)
        when 'Debts::DebtAggregate::UnableToCorrectDebtDetails'
          error!(e, 403)
        when 'Debts::DebtAggregate::UnableToAccept'
          error!(e, 403)
        when 'NoMethodError'
          error!('Could not find the requested resource', 404)
        when 'Groups::GroupAggregate::MemberNotAllowed'
          error!(e, 403)
        when 'Groups::GroupAggregate::GroupDoesNotExist'
          error!(e, 404)
        when 'Groups::GroupAggregate::UnpermittedRepaymentDate'
          error!(e, 403)
        when 'Groups::GroupAggregate::OperationNotPermitted'
          error!(e, 403)
        when 'Groups::GroupAggregate::NotEntitledToCloseGroup'
          error!(e, 403)
        when 'ActiveRecord::RecordNotFound'
          error!(e, 404)
        else
          #error!(e, 500)
          error!('Something went wrong!', 500)
        end
      end 
    end
  end
end