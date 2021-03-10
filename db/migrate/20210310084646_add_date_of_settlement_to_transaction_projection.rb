class AddDateOfSettlementToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :date_of_settlement, :datetime
  end
end
