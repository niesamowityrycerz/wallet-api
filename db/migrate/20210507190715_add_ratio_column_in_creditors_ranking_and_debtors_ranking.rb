class AddRatioColumnInCreditorsRankingAndDebtorsRanking < ActiveRecord::Migration[5.2]
  def change
    add_column :creditors_ranking, :ratio, :float 
    add_column :debtors_ranking, :ratio, :float
  end
end
