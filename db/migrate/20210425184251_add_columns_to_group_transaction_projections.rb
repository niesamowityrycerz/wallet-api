class AddColumnsToGroupTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :group_transaction_projections, :debtors_ids, :string
    add_column :group_transaction_projections, :creditor_id, :integer
    add_column :group_transaction_projections, :group_uid, :string
    add_column :group_transaction_projections, :description, :string 
    add_column :group_transaction_projections, :total_amount, :float 
    add_column :group_transaction_projections, :currency_id, :integer
    add_column :group_transaction_projections, :state, :integer
    add_column :group_transaction_projections, :date_of_transaction, :date 
    add_column :group_transaction_projections, :group_transaction_uid, :string 
  end
end
