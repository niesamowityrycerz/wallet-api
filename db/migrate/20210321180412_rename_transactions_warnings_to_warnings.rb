class RenameTransactionsWarningsToWarnings < ActiveRecord::Migration[5.2]
  def change
    rename_table :transaction_warnings, :warnings 
  end
end
