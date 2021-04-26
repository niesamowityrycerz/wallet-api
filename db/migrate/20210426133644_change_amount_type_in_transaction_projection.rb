class ChangeAmountTypeInTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    remove_column :transaction_projections, :amount
    add_column :transaction_projections, :amount, :float
  end
end
