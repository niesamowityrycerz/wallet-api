class AddColumnsToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    remove_column :transaction_projections, :issuer_id
    remove_column :transaction_projections, :issuer_uid
    remove_column :transaction_projections, :borrower_name
    add_column    :transaction_projections, :currency_id, :integer
    add_column    :transaction_projections, :creditor_id, :integer
    add_column    :transaction_projections, :debtor_id, :integer
    add_column    :transaction_projections, :description, :string
    add_column    :transaction_projections, :maturity, :string
    add_column    :transaction_projections, :interest, :float
    add_column    :transaction_projections, :repayment_type_id, :integer
  end
end
