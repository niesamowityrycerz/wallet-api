module Debts
  class DebtsStataSerializer 
    include JSONAPI::Serializer 

    attribute :total_accepted do |debt|
      debt.accepted.count 
    end

    attribute :total_closed do |debt|
      debt.closed.cont
    end
  end
end