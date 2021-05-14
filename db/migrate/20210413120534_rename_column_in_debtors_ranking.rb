class RenameColumnInDebtorsRanking < ActiveRecord::Migration[5.2]
  def change
    remove_column :debtor_rankings, :transaction_counter
    add_column    :debtor_rankings, :debt_transactions, :integer, default: 0
  end
end
