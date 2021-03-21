class CreateTransactionWarnings < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_warnings do |t|

      t.timestamps
    end
  end
end
