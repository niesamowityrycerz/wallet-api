class WarningType < ApplicationRecord
  validates :name, presence: true
  has_many :debt_warnings
end
