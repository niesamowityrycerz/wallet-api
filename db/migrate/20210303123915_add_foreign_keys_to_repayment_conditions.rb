class AddForeignKeysToRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    add_reference :repayment_conditions, :creditor, references: :users, index: true
    add_reference :repayment_conditions, :repayment_types
  end
end
