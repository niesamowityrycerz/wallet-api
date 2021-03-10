class ChangeNameOfRepaymentTypesToRepaymentMethods < ActiveRecord::Migration[5.2]
  def change
    rename_table 'repayment_types', 'repayment_methods'
  end
end
