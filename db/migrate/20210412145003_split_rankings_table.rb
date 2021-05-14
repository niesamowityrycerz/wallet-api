class SplitRankingsTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :rankings, :debtor_rankings
  end
end
