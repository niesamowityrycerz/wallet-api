class ChangeMaturityColumnInRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    remove_column :repayment_conditions, :maturity 
    add_column :repayment_conditions, :maturity_in_days, :integer, default: :nil 
  end
end
