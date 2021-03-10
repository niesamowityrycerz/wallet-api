class CreateFaithPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :faith_points do |t|
      t.float :points

      t.timestamps
    end
  end
end
