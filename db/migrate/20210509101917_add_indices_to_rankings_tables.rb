class AddIndicesToRankingsTables < ActiveRecord::Migration[5.2]
  def change
    add_index :creditor_rankings, :creditor_id
    add_index :debtor_rankings, :debtor_id 
  end
end
