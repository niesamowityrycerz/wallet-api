class CreateGroupProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :group_projections do |t|
      t.string :group_uid
      t.string :name
      t.integer :leader_id
      t.date :from
      t.date :to

      t.timestamps
    end
  end
end
