class RenameRankingTables < ActiveRecord::Migration[5.2]
  def change
    rename_table :creditors_ranking, :creditor_rankings
    rename_table :debtors_ranking,   :debtor_rankings
  end
end
