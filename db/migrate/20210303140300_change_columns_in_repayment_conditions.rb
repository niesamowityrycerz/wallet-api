class ChangeColumnsInRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    remove_column :repayment_conditions, :date_from
    remove_column :repayment_conditions, :date_to
    add_column    :repayment_conditions, :maturity, :string 
  end
end
