module ReadModels
  module Warnings
    class DebtWarningProjection < ApplicationRecord
      belongs_to :user
    end
  end
end
