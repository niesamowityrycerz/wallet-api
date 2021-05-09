class AddIndicesToRankingsTables < ActiveRecord::Migration[5.2]
  def change
    add_index :creditors_ranking, :creditor_id
    add_index :debtors_ranking, :debtor_id 
  end
end
