class AddReasoForClosingToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :reason_for_closing, :string
  end
end
