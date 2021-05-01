require 'rails_helper'
require 'helpers/friendships'

include Friendship



RSpec.describe 'Group Debt actions', type: :unit do 

  let(:creditor)              { create(:user) }
  let(:debtor_1)              { create(:user) }
  let(:debtor_2)              { create(:user) }
  let(:debtor_3)              { create(:user) }


  let(:zloty)               { create(:currency) }
  let(:euro)                { create(:currency, :euro) }
  let(:one_instalment)      { create(:settlement_method) }
  let(:many_installments)   { create(:settlement_method, :multiple_instalments) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }

  before(:all) do 
    @debt_uid = SecureRandom.uuid
  end

  before(:each) do
    create_friendships(creditor, Array.new([debtor_1, debtor_2, debtor_3]))

    @issue_tran_params = {
      debt_uid: @debt_uid,
      creditor_id: creditor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today,
      group_debt: true,
      group_uid: SecureRandom.uuid
    }
  end



  it 'issues group debt' do
    #issue_debt = Debts::Commands::IssueDebt.send(@issue_tran_params)
    #expect {
    #  command_bus.call(issue_transaction)
    #}.to 
  end


  

  
end