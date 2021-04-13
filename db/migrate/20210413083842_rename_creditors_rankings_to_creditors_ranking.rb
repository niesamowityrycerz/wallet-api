class RenameCreditorsRankingsToCreditorsRanking < ActiveRecord::Migration[5.2]
  def change
    rename_table :creditors_rankings, :creditors_ranking
  end
end
