class DropPenaltyPoints < ActiveRecord::Migration[5.2]
  def change
    drop_table :penalty_points
  end
end
