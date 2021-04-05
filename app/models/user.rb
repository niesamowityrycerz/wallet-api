class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_many :repayment_conditions, foreign_key: :creditor_id, dependent: :destroy

  has_many :transaction_warnings
  has_many :transaction_warning_projections, class_name: 'ReadModels::Warnings::TransactionWarningProjection'
  has_many :financial_ransactions,  foreign_key: :creditor_id, class_name: 'WriteModels::FinancialTransactions'
  has_many :financial_transactions, foreign_key: :debtor_id,   class_name: 'WriteModels::FinancialTransactions'

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

end
