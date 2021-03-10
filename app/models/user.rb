class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_many :repayment_conditions, foreign_key: :creditor_id, dependent: :destroy
  has_many :credibility_points,   foreign_key: :debtor_id
  has_many :faith_points,         foreign_key: :creditor_id 

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

end
