class RemoveUserReferenceInRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :repayment_conditions, :creditor
  end
end
 