class DropCredibilityPointProjection < ActiveRecord::Migration[5.2]
  def change
    drop_table :credibility_points_projections
  end
end
