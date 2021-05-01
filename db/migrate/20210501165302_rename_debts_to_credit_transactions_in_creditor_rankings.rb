class RenameDebtsToCreditTransactionsInCreditorRankings < ActiveRecord::Migration[5.2]
  def change
    rename_column :creditors_ranking, :debts, :credits_quantity
    rename_column :debtors_ranking, :debt_transactions, :debts_quantity 
  end
end
