class AddTransactionProjectionReferenceToCredibilityPointsProjection < ActiveRecord::Migration[5.2]
  def change
    add_reference :credibility_points_projections, :transaction_projection, foreign_key: true, index: { name: 'index_cred_points_projection_on_tran_projection' } 
  end
end
