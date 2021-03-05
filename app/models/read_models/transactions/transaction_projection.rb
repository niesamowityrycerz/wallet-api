module ReadModels
  module Transactions 
    class TransactionProjection < ApplicationRecord
      # status column is of type Integer;
      # Rails will do the mapping and transalte: 
      # 0 -> pending, 1 -> rejected, 2 -> accepted
      # enum status: { pending: 0, accepted: 1, rejected: 2 }, default: :pending 
      enum status: { pending: 0, accepted: 1, rejected: 2 }
    end
  end
end

