class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.date :from
      t.date :to

      t.timestamps
    end
  end
end
