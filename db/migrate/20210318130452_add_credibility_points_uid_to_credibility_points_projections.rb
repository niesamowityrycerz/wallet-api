class AddCredibilityPointsUidToCredibilityPointsProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :credibility_points_projections, :credibility_points_uid, :string
  end
end
