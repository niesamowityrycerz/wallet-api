class ChangePenaltyPointsDefaultValueToTransactionProjectios < ActiveRecord::Migration[5.2]
  def change
    change_column :transaction_projections, :penalty_points, :float, default: 0
  end
end
