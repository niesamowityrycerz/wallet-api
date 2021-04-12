class AddRemoveColumnsInTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    remove_columns :transaction_projections, :max_date_of_settlement, :admin_informed, :message_to_admin
    add_column    :transaction_projections, :anticipated_date_of_settlement, :date 
  end
end
