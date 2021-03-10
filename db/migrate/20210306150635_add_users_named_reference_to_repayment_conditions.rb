class AddUsersNamedReferenceToRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    add_reference :repayment_conditions, :creditor, references: :users, index: true 
  end
end
