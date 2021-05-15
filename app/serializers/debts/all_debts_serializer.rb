module Debts
  class AllDebtsSerializer < BaseDebtSerializer
    include JSONAPI::Serializer

    link :detailed_info do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}"
    end
  
  end 
end
