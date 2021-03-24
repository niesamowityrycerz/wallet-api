class AddReasonForRejectionColumnToTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :reason_for_rejection, :string
  end
end
