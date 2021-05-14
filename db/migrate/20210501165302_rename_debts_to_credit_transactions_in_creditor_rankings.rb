class RenameDebtsToCreditTransactionsInCreditorRankings < ActiveRecord::Migration[5.2]
  def change
    rename_column :creditor_rankings, :debts, :credits_quantity
    rename_column :debtor_rankings, :debt_transactions, :debts_quantity 
  end
end
