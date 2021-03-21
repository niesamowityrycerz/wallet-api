class AddReferencesAndColumnsToTransactionWarningsProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_warning_projections, :warning_type_name, :string
    add_column :transaction_warning_projections, :transaction_uid, :string 
    add_column :transaction_warning_projections, :warning_uid, :string
    add_column :transaction_warning_projections, :penalty_points, :float
    add_reference :transaction_warning_projections, :user, foreign_key: true 
    

  end
end
