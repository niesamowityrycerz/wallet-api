module WriteModels 
  class Debt < ApplicationRecord
    #belongs_to :debt_projection, class_name: 'ReadModels::Debts::DebtProjection'

    enum state: { pending: 0, accepted: 1, rejected: 2,
                  closed: 4, settled: 6, expired: 7 }

    belongs_to :debtor,   class_name: 'User'
    belongs_to :creditor, class_name: 'User'

    has_many :debt_warnings 
    has_many :warnings, class_name: 'WriteModels::Warning', through: :debt_warnings
  end 
end
