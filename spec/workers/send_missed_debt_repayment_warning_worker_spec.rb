require 'rails_helper'

RSpec.describe 'Send missed debt repayment warning worker', type: :unit do 

  let(:transaction_uid)           { SecureRandom.uuid }
  let(:debtor)                    { create(:debtor) }

  context 'when debtor does not repay in time' do 
    it 'invokes PrepareToSendDebtExpiredWarning job' do
      execute_in = 5

      Warnings::PrepareToSendMissedDebtRepaymentWarning.perform_in(execute_in.seconds, transaction_uid, debtor.id)
      expect(Warnings::PrepareToSendMissedDebtRepaymentWarning).to have_enqueued_sidekiq_job(transaction_uid, debtor.id)
      # ensure execution of job
      job_put_in_queue_at = Warnings::PrepareToSendMissedDebtRepaymentWarning.jobs[0]['created_at']
      job_executed_at = Warnings::PrepareToSendMissedDebtRepaymentWarning.jobs[0]['at']
      expect((job_executed_at - job_put_in_queue_at).round(3)).to eq(execute_in.to_f)
    end
  end 
end