class AddTransactionDateToTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :transaction_date, :datetime
  end
end
