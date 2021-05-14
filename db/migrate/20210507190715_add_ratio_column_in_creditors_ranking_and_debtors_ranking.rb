class AddRatioColumnInCreditorsRankingAndDebtorsRanking < ActiveRecord::Migration[5.2]
  def change
    add_column :creditor_rankings, :ratio, :float 
    add_column :debtor_rankings, :ratio, :float
  end
end
