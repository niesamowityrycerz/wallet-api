class CreateTransactionWarningProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_warning_projections do |t|

      t.timestamps
    end
  end
end
