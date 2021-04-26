module ReadModels  
  module Groups 
    class GroupTransactionProjection < ApplicationRecord
      serialize :recievers_ids

      enum state: { init: 0, closed: 1, settled: 2 }
    end
  end 
end 
