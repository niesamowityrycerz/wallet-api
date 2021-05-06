module WriteModels
  class RepaymentCondition < ApplicationRecord
  belongs_to :currency
  belongs_to :creditor, class_name: 'User'

  validates :maturity_in_days, presence: true
  end
end 
