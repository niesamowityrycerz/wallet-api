class CreateRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :rankings do |t|

      t.timestamps
    end
  end
end
