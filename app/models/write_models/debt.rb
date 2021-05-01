module WriteModels 
  class Debt < ApplicationRecord
    #belongs_to :debt_projection, class_name: 'ReadModels::Debts::DebtProjection'
    belongs_to :debtor,   class_name: 'User'
    belongs_to :creditor, class_name: 'User'

    has_many :debt_warnings 
    has_many :warnings, class_name: 'WriteModels::Warning', through: :debt_warnings
  end 
end
