class Currency < ApplicationRecord
  has_many :repayment_conditions

  validates :name, presence: true
  validates :code, presence: true
end
