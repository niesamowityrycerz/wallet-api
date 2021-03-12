class RenameFaithPointsToTrustPoints < ActiveRecord::Migration[5.2]
  def change
    rename_table :faith_points, :trust_points
  end
end
