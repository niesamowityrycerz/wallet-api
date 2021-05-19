RSpec.shared_examples 'on correcting debt' do |attribute|

  let(:debt_uid)         { SecureRandom.uuid }
  let!(:debt_projection) { create(:debt_projection, :pending, debt_uid: debt_uid) }


  attribute.each do |key, value|
    it "corrects #{key}" do 
      debt_p = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
      before = debt_p.send(key.to_sym)

      params = { debt_uid: debt_uid }
      params.merge!({key => value})

      expect {
        command_bus.call(Debts::Commands::CorrectDebtDetails.new(params))
      }.to change { ReadModels::Debts::DebtProjection.first.send(key.to_sym) }.from(before).to(value)
      
      expect(event_store).to have_published(
        an_event(Debts::Events::DebtDetailsCorrected)
      ).in_stream("Debt$#{debt_uid}")
    end 
  end 
end