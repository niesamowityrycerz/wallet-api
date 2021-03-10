class RenameRepaymentMethodColumnTableAndForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_reference :repayment_conditions, :repayment_method, index: true, foreign_key: true 
    rename_table 'repayment_methods', 'settlement_methods'
    add_reference    :repayment_conditions, :settlement_method

  end
end
