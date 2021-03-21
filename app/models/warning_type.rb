class WarningType < ApplicationRecord
  validates :name, presence: true
  has_many :transaction_warnings
end
