module Api
  module V1
    module Debts
      module DebtFilters 
        extend Grape::API::Helpers 

        params :debt_filters do |_options|
          optional :filters, type: Hash do 
            optional :date_of_debt, type: Date 
            optional :amount, type: Hash
            given :amount do 
              requires :max, type: Integer, values: ->(val) { val < 10000.0 }
              requires :min, type: Integer, values: ->(val) { val > 0.0 }
              all_or_none_of :max, :min 
            end
            optional :status, type: Array, values: %i[pending rejected closed]
            optional :users, type: Array, values: -> { User.ids }
            optional :type, type: String, values: %w[borrow lend]
          end
        end
      end

      class Base < Api::V1::Base

        helpers(
          DebtFilters
        ) 

        resource :debts do 
          mount Api::V1::Debts::All
        end 

        resource :debt do
          route_param :debt_uid do 
            mount Api::V1::Debts::Index
            mount Api::V1::Debts::IssueDebt
            mount Api::V1::Debts::AcceptDebt
            mount Api::V1::Debts::RejectDebt
            mount Api::V1::Debts::CheckOutDebtDetails
            mount Api::V1::Debts::CorrectDebtDetails
            mount Api::V1::Debts::SettleDebt
            mount Api::V1::Debts::CloseDebt
            mount Api::V1::Debts::AddAnticipatedSettlementDate  
          end 
        end
      end
    end
  end
end