RSpec.shared_examples 'on correcting transaction' do |attribute|

  let(:transaction_uid)         { SecureRandom.uuid }
  let!(:transaction_projection) { create(:transaction_projection, :pending, transaction_uid: transaction_uid) }


  attribute.each do |key, value|
    it "corrects #{key}" do 
      transaction_p = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)
      before = {
        description: transaction_p.description,
        amount: transaction_p.amount,
        currency_id: transaction_p.currency_id,
        date_of_transaction: transaction_p.date_of_transaction
      }

      params = { transaction_uid: transaction_uid }
      params.merge!({key => value})

      command_bus.call(Transactions::Commands::CorrectTransaction.new(params))
      updated_transaction_p = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)
      after = {
        description: updated_transaction_p.description,
        amount: updated_transaction_p.amount,
        currency_id: updated_transaction_p.currency_id,
        date_of_transaction: updated_transaction_p.date_of_transaction
      }

      expect(before.except(key)).to eq(after.except(key))
      expect(updated_transaction_p.as_json[key.to_s]).to eq(value)

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionCorrected)
      ).in_stream("Transaction$#{transaction_uid}")
    end 
  end 
end