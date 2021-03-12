class AddAdjustedCredibilityPointsToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :adjusted_credibility_points, :float
  end
end
