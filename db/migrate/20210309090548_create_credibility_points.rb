class CreateCredibilityPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :credibility_points do |t|
      t.float :points

      t.timestamps
    end
  end
end
