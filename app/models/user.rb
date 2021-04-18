class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_many :repayment_conditions, class_name: 'WriteModels::RepaymentCondition', foreign_key: "creditor_id", dependent: :destroy

  has_many :transaction_warnings
  has_many :transaction_warning_projections, class_name: 'ReadModels::Warnings::TransactionWarningProjection'
  has_many :financial_ransactions, class_name: 'WriteModels::FinancialTransaction', foreign_key: "creditor_id"
  has_many :financial_transactions,  class_name: 'WriteModels::FinancialTransaction', foreign_key: "debtor_id"

  has_one :debtors_ranking, class_name: 'WriteModels::DebtorsRanking', foreign_key: 'debtor_id', dependent: :destroy
  has_one :creditors_ranking, class_name: 'WriteModels::CreditorsRanking', foreign_key: 'creditor_id', dependent: :destroy 

  has_many :group_members, foreign_key: 'member_id'
  has_many :groups, through: :group_members

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

end
