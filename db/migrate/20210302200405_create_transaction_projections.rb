class CreateTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_projections do |t|
      t.integer :issuer_id
      t.string :issuer_uid
      t.string :transaction_uid
      t.string :borrower_name
      t.integer :amount

      t.timestamps
    end
  end
end
