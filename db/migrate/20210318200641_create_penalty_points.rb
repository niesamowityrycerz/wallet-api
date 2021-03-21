class CreatePenaltyPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :penalty_points do |t|

      t.timestamps
    end
  end
end
