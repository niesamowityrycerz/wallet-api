class ChangeColumnTypeDebtUidInDebts < ActiveRecord::Migration[5.2]
  def change
    change_column :debts, :debt_uid, :string
  end
end
