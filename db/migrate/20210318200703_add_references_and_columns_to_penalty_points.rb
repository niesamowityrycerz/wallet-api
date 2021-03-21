class AddReferencesAndColumnsToPenaltyPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :penalty_points, :points, :float
    add_reference :penalty_points, :transaction_warning, foreign_key: true 
  end
end
