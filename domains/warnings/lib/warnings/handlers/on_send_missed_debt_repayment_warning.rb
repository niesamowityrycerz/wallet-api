module Warnings 
  module Handlers 
    class OnSendMissedDebtRepaymentWarning 
      include CommandHandler

      def call(command)
        debt_uid = command.data[:debt_uid]

        repository = Repositories::Warning.new
        repository.with_warning(debt_uid) do |warning|
          params = command.data.merge({
            warning_type_id: WarningType.find_by!(name: 'missed repayment date').id,
            warning_uid: SecureRandom.uuid 
          })
          warning.missed_repayment(params)
        end
      end
    end
  end
end