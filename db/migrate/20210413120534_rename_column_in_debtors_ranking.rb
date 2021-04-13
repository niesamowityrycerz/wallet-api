class RenameColumnInDebtorsRanking < ActiveRecord::Migration[5.2]
  def change
    remove_column :debtors_ranking, :transaction_counter
    add_column    :debtors_ranking, :debt_transactions, :integer, default: 0
  end
end
