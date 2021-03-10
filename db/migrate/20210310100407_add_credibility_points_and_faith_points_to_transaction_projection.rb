class AddCredibilityPointsAndFaithPointsToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :credibility_points, :float
    add_column :transaction_projections, :faith_points, :float
  end
end
