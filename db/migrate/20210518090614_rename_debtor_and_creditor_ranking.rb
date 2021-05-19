class RenameDebtorAndCreditorRanking < ActiveRecord::Migration[5.2]
  def change
    rename_table :debtor_rankings, :debtor_ranking_projections
    rename_table :creditor_rankings, :creditor_ranking_projections
  end
end
