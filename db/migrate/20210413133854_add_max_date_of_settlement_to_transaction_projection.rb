class AddMaxDateOfSettlementToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    remove_column :transaction_projections, :maturity_in_days
    add_column :transaction_projections, :max_date_of_settlement, :date
  end
end
