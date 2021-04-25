class CreateGroupTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :group_transaction_projections do |t|

      t.timestamps
    end
  end
end
