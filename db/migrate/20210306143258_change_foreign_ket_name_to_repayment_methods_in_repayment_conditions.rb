class ChangeForeignKetNameToRepaymentMethodsInRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :repayment_conditions, :repayment_type
    add_reference    :repayment_conditions, :repayment_method
  end 
end
