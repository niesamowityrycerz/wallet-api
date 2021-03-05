class ChangeMaturityColumnInTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    remove_column :transaction_projections, :maturity
    add_column :transaction_projections, :maturity_in_days, :integer
  end
end
