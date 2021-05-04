module Debts
  class AllDebtsSerializer < BaseDebtSerializer
    include JSONAPI::Serializer

    #attributes :total_accepted, :total_closed, :total_rejected

    link :detailed_info do |debt|
      "localhost:3000/api/v1/debt/#{debt.debt_uid}"
    end

    #meta do |params|
    #  binding.pry 
    #  {
    #    total_accepted: debts.accepted.count,
    #    total_closed: debts.closed.count,
    #    total_rejected: debts.rejected.count,
    #    total_pending: debts.pending.count,
    #    total_settled: debts.settled.count
    #  }
    #end 
  
  end 
end
