class RenameFaithPointsColumnAndAddPenaltyCredibilityPointsToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :penalty_points, :float 
    rename_column :transaction_projections, :faith_points, :trust_points
  end
end
