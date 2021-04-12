require 'rails_helper'

RSpec.describe 'Send transaction expired warning worker', type: :unit do 

  let(:transaction_uid)           { SecureRandom.uuid }
  let(:debtor)                    { create(:debtor) }

  context 'when debtor does not repay in time' do 
    it 'invokes PrepareToSendTransactionExpiredWarning job' do
      # define sidekiq job -> queue name is 'warnings
      execute = 5
      # expect(Warnings::PrepareToSendTransactionExpiredWarning).to be_processed_in 'warnings'
      Warnings::PrepareToSendTransactionExpiredWarning.perform_in(execute.seconds, transaction_uid, debtor.id)
      expect(Warnings::PrepareToSendTransactionExpiredWarning).to have_enqueued_sidekiq_job(transaction_uid, debtor.id)
      # ensure execution of job
      job_put_in_queue_at = Warnings::PrepareToSendTransactionExpiredWarning.jobs[0]['created_at']
      job_executed_at = Warnings::PrepareToSendTransactionExpiredWarning.jobs[0]['at']
      expect((job_executed_at - job_put_in_queue_at).round(3)).to eq(execute.to_f)
    end
  end 
end