module WriteModels
  class RepaymentCondition < ApplicationRecord
  belongs_to :creditor, class_name: 'User', foreign_key: 'creditor'
  belongs_to :repayment_type
  belongs_to :currency

  validates :maturity, presence: true
  validates :interest , numericality: { greater_than: 0 }, allow_nil: true 
  end
end 
