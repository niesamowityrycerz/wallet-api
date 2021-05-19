require 'rails_helper'

RSpec.describe 'Creditor Rankings', type: :integration do 

  let(:debt_uid)             { SecureRandom.uuid }
  let(:creditor)             { create(:creditor, :with_some_ranking_data) }
  let(:debtor)               { create(:debtor, :with_some_ranking_data) }
  let(:zloty)                { create(:currency) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }

  before(:each) do
    @issue_tran_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }

    @settle_params = {
      debt_uid: debt_uid,
      date_of_settlement: Date.today,
      amount: @issue_tran_params[:amount],
      debtor_id: @issue_tran_params[:debtor_id]
    }

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
    command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
  end

  context 'when debt settlement succedded' do 
    it 'checks trust points update' do 
      trust_points_before = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).trust_points

      command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))

      change = event_store.read.stream("RankingPoint$#{debt_uid}").to_a.second.data[:trust_points]
      trust_points_after = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).trust_points

      expect(trust_points_after).to eq(trust_points_before + change)
    end 

    it 'checks ratio update' do
      creditor_ratio_before = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).ratio
      credits_quantity = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).credits_quantity

      command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))

      trust_points_after = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).trust_points
      anticipated_creditor_ratio = (trust_points_after/(credits_quantity + 1)).round(2)
      creditor_ratio_after = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).ratio

      expect(creditor_ratio_after).to eq(anticipated_creditor_ratio)
    end 

    it 'checks updated credits quantity' do 
      expect {
        command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))
      }.to change { ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: creditor.id).credits_quantity }.by(1)
    end 
  end
end