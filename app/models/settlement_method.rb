class SettlementMethod < ApplicationRecord
  has_many :repayment_conditions

  validates :name, presence: true
end
