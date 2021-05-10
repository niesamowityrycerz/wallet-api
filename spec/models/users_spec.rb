require 'rails_helper'

RSpec.describe User, type: :model do 

  let(:admin_attr)     { attributes_for(:user, :admin) }
  let(:user_attr)      { attributes_for(:user) }

  context 'when register admin' do 
    it 'alters admin username' do 
      User.create!(admin_attr)
      expect(User.find_by!(email: admin_attr[:email]).username).to eq(admin_attr[:username] + '_admin')
    end
  end

  it 'registers regular user' do 
    User.create!(user_attr)
    expect(User.find_by!(email: user_attr[:email]).username).not_to eq(user_attr[:username] + '_admin')
  end

  it 'registers user' do
    expect {
      User.create!(user_attr)
    }.to change { ReadModels::Rankings::DebtorRanking.count }.by(1)
    .and change { ReadModels::Rankings::CreditorRanking.count }.by(1)
    
    added_user_id = User.find_by!(email: user_attr[:email]).id
    expect(ReadModels::Rankings::DebtorRanking.find_by!(debtor_id: added_user_id).present? ).to eq(true)
    expect(ReadModels::Rankings::CreditorRanking.find_by!(creditor_id: added_user_id).present? ).to eq(true)
  end
end