class AddReferencesToCredibilityPoints < ActiveRecord::Migration[5.2]
  def change
    add_reference :credibility_points, :debtor, references: :users, index: true 
    add_reference :credibility_points, :transaction_projections
  end
end
