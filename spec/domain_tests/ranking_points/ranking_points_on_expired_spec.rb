require 'rails_helper'

RSpec.describe 'Ranking points flow', type: :unit do
  let(:transaction_uid)    { SecureRandom.uuid }
  let(:debtor)             { create(:debtor) }
  let!(:tran_projection)    { create(:transaction_projection, transaction_uid: transaction_uid, debtor_id: debtor.id) }
  let!(:warning_type)      { create(:warning_type) }


  before(:each) do
    @transaction_expired_params = {
      transaction_uid: transaction_uid,
      debtor_id: debtor.id
    }
  end

  context 'when transaction expired' do 
    it 'checks added penalty points' do
      expect {
        command_bus.call(Warnings::Commands::SendTransactionExpiredWarning.new(@transaction_expired_params))
      }.to change { ReadModels::Warnings::TransactionWarningProjection.count }.by(1)
       .and change { WriteModels::Warnings::TransactionWarning.count }.by(1)

      warning_uid = event_store.read.stream("Transaction$#{transaction_uid}").to_a[-1].data[:warning_uid]
      expect(ReadModels::Warnings::TransactionWarningProjection.find_by!(warning_uid: warning_uid).penalty_points).not_to eq(0)
      expect(WriteModels::Warnings::TransactionWarning.find_by!(warning_uid: warning_uid).penalty_points).not_to eq(nil)
      
      expect(event_store).to have_published(
        an_event(Warnings::Events::TransactionExpiredWarningSent)
      ).in_stream("TransactionWarning$#{transaction_uid}")

      expect(event_store).to have_published(
        an_event(Warnings::Events::TransactionExpiredWarningSent)
      ).in_stream("Transaction$#{transaction_uid}")

      expect(event_store).to have_published(
        an_event(CredibilityPoints::Events::PenaltyPointsAdded)
      ).in_stream("CredibilityPoint$#{transaction_uid}")
    end
  end
end