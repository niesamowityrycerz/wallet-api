class CreateCredibilityPointsProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :credibility_points_projections do |t|
      t.float :credibility_points
      t.integer :penalty_points

      t.timestamps
    end
  end
end
