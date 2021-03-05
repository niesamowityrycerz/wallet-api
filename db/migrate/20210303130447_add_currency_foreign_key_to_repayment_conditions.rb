class AddCurrencyForeignKeyToRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    add_reference :repayment_conditions, :currency 
  end
end
