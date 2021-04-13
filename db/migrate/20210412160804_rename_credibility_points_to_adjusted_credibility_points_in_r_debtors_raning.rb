class RenameCredibilityPointsToAdjustedCredibilityPointsInRDebtorsRaning < ActiveRecord::Migration[5.2]
  def change
    rename_column :debtors_ranking, :credibility_points, :adjusted_credibility_points
  end
end
