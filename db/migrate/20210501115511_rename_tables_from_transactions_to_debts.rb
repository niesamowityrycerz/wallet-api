class RenameTablesFromTransactionsToDebts < ActiveRecord::Migration[5.2]
  def change
    rename_table :transaction_projections, :debt_projections
    rename_table :transaction_warning_projections, :debt_warning_projections
    rename_table :group_transaction_projections, :group_debt_projeections 
    rename_table :financial_transactions, :debts
  end
end
