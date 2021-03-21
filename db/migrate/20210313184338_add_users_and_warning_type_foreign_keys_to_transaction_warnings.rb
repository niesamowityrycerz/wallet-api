class AddUsersAndWarningTypeForeignKeysToTransactionWarnings < ActiveRecord::Migration[5.2]
  def change
    add_reference :transaction_warnings, :user, foreign_key: true 
    add_reference :transaction_warnings, :warning_type
  end
end
