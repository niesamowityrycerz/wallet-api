RSpec.shared_examples 'on correcting debt' do |attribute|

  let(:debt_uid)                { SecureRandom.uuid }
  let(:creditor)                { create(:creditor) }
  let(:debtor)                  { create(:debtor) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }


  before(:each) do 
    @issue_debt_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
    command_bus.call(Debts::Commands::IssueDebt.send(@issue_debt_params))

    @check_out_details_params = { 
      debt_uid: debt_uid,
      doubts: 'test'
    }
    command_bus.call(Debts::Commands::CheckOutDebtDetails.send(@check_out_details_params))
  end


  attribute.each do |key, value|

    it "corrects #{key}" do 
      before = @issue_debt_params[key] 

      params = { debt_uid: debt_uid }
      params.merge!({key => value})

      expect {
        command_bus.call(Debts::Commands::CorrectDebtDetails.new(params))
      }.to change { ReadModels::Debts::DebtProjection.where(debt_uid: debt_uid)[-1].send(key.to_sym) }.from(@issue_debt_params[key]).to(value)

      expect(event_store).to have_published(
        an_event(Debts::Events::DebtDetailsCorrected)
      ).in_stream("Debt$#{debt_uid}")
    end 
  end 
end