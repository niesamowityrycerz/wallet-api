class RenameColumnsFromTransactionsToDebts < ActiveRecord::Migration[5.2]
  def change
    rename_column :creditor_rankings, :credit_transactions, :debts
    rename_column :debt_projections, :transaction_uid, :debt_uid 
    rename_column :debt_projections, :group_transaction, :group_debt

    rename_column :debt_warning_projections, :transaction_uid, :debt_uid 

    add_column     :debts, :debt_uid, :string

    rename_table :group_debt_projeections, :group_debt_projections 
    rename_column :group_debt_projections, :group_transaction_uid, :group_debt_uid 

    rename_column :warnings, :transaction_uid, :debt_uid

    rename_column :group_projections, :transactions_expired_on, :debt_repayment_valid_till
  end
end
