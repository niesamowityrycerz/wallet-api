module WriteModels
  class RepaymentCondition < ApplicationRecord
  belongs_to :settlement_method
  belongs_to :currency
  belongs_to :creditor, class_name: 'User', foreign_key: 'creditor_id'

  validates :maturity_in_days, presence: true
  end
end 
