class AddForeignKeysToCredibilityPoints < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :credibility_points, :users, column: :debtor_id 
    add_foreign_key :credibility_points, :transaction_projections
  end
end
