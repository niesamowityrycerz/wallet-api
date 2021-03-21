module ReadModels
  module Warnings
    class TransactionWarningProjection < ApplicationRecord
      belongs_to :user
    end
  end
end
