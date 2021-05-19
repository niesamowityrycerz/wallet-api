class AddDefaultValueToRatioInRankings < ActiveRecord::Migration[5.2]
  def change
    change_column :creditor_ranking_projections, :ratio, :decimal, default: 0.0
    change_column :debtor_ranking_projections, :ratio, :decimal, default: 0.0
  end
end
