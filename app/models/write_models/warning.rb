module WriteModels
  class Warning < ApplicationRecord
    belongs_to :user
    belongs_to :warning_type

    has_many :debt_warnings 
    has_many :debt_transactions, class_name: 'WriteModels::Debt', through: :debt_warnings
  end
end

