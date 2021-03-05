class AddMaxDateOfTransactionSettlementAndChangeTransactionDateToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :max_date_of_settlement, :datetime 
    remove_column :transaction_projections, :transaction_date
    add_column :transaction_projections, :date_of_transaction, :datetime 
  end
end
