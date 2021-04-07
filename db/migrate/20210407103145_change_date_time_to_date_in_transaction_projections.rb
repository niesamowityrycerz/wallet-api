class ChangeDateTimeToDateInTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    change_column :transaction_projections, :date_of_transaction, :date
  end
end
