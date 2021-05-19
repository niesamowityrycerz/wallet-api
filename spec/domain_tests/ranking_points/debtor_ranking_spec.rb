require 'rails_helper'

RSpec.describe 'Ranking position changes', type: :integration do 
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
    it 'checks updated adjusted credibility points' do 
      adj_credibility_points_before = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).adjusted_credibility_points

      command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))

      change = event_store.read.stream("RankingPoint$#{debt_uid}").to_a.first.data[:adjusted_credibility_points]
      adj_cred_points_after = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).adjusted_credibility_points

      expect(adj_cred_points_after).to eq(adj_credibility_points_before + change)
    end

    it 'checks updated ratio' do 
      debtor_ratio_before = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).ratio
      debts_q = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).debts_quantity

      command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))

      adj_cred_points_after = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).adjusted_credibility_points
      debtor_ratio_after = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).ratio
      anticipated_debtors_ratio = (adj_cred_points_after/(debts_q + 1)).round(2)

      expect(debtor_ratio_after).to eq(anticipated_debtors_ratio)
    end

    it 'checks updated debts quantity' do 
      expect {
        command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))
      }.to change { ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: debtor.id).debts_quantity }.by(1)
    end
  end 
end 