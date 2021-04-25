class AddDueMoneyPerDebtorToGroupTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :group_transaction_projections, :due_money_per_debtor, :float 
  end
end
