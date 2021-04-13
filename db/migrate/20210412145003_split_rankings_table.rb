class SplitRankingsTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :rankings, :debtors_ranking
  end
end
