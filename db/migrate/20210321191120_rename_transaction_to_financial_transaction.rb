class RenameTransactionToFinancialTransaction < ActiveRecord::Migration[5.2]
  def change
    rename_table :transactions, :financial_transactions
  end
end
