class AddStateColumnToDebts < ActiveRecord::Migration[5.2]
  def change
    add_column :debts, :state, :integer, default: 0
  end
end
