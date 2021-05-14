class RenameCredibilityPointsToAdjustedCredibilityPointsInRDebtorsRaning < ActiveRecord::Migration[5.2]
  def change
    rename_column :debtor_rankings, :credibility_points, :adjusted_credibility_points
  end
end
