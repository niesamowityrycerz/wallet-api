class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_many :repayment_conditions, class_name: 'WriteModels::RepaymentCondition', foreign_key: "creditor_id", dependent: :destroy

  has_many :debt_warnings
  has_many :debt_warning_projections, class_name: 'ReadModels::Warnings::DebtWarningProjection'
  has_many :debts, class_name: 'WriteModels::Debt', foreign_key: "creditor_id"
  has_many :debts,  class_name: 'WriteModels::Debt', foreign_key: "debtor_id"

  has_many :group_members, foreign_key: 'member_id', class_name: 'WriteModels::GroupMembers'
  has_many :groups, through: :group_members

  # enable friendship(gem)
  has_friendship

  before_create :alter_admin_username
  after_create :add_to_ranking

  

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  #def self.friendship_errors(requested_user)
  #  binding.pry
  #end

  private 

  def alter_admin_username 
    if self.admin == true 
      self.username = self.username + "_admin"
    end
  end

  def add_to_ranking 
    ReadModels::Rankings::DebtorRanking.create!(debtor_id: self.id, debtor_name: self.username)
    ReadModels::Rankings::CreditorRanking.create!(creditor_id: self.id, creditor_name: self.username)
  end
end
