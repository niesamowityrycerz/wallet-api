class FixReferenceToCredibilityPoints < ActiveRecord::Migration[5.2]
  def change
    remove_reference :credibility_points, :transaction_projections
    add_reference    :credibility_points, :transaction_projection
  end
end
