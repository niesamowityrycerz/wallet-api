RSpec.shared_examples 'on correcting debt' do |attribute|

  let(:debt_uid)         { SecureRandom.uuid }
  let!(:debt_projection) { create(:debt_projection, :pending, debt_uid: debt_uid) }


  attribute.each do |key, value|
    it "corrects #{key}" do 
      debt_p = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
      before = {
        description: debt_p.description,
        amount: debt_p.amount,
        currency_id: debt_p.currency_id,
        date_of_transaction: debt_p.date_of_transaction
      }

      params = { debt_uid: debt_uid }
      params.merge!({key => value})

      command_bus.call(Debts::Commands::CorrectDebtDetails.new(params))
      updated_debt_p = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
      after = {
        description: updated_debt_p.description,
        amount: updated_debt_p.amount,
        currency_id: updated_debt_p.currency_id,
        date_of_transaction: updated_debt_p.date_of_transaction
      }

      expect(before.except(key)).to eq(after.except(key))
      expect(updated_debt_p.as_json[key.to_s]).to eq(value)

      expect(event_store).to have_published(
        an_event(Debts::Events::DebtDetailsCorrected)
      ).in_stream("Debt$#{debt_uid}")
    end 
  end 
end