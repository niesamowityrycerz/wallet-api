class AddColumnsAndReferencesToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :debtor,   foreign_key: { to_table: :users }
    add_reference :transactions, :creditor, foreign_key: { to_table: :users }
    add_column    :transactions, :amount, :float
    add_reference :transactions, :transaction_projection, foreign_key: true 
    add_column    :transactions, :date_of_transaction, :datetime
  end
end
